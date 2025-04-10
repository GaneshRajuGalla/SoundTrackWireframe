//
//  OnboardingFiveViewController.swift
//  SoundTrack wireframe
//
//  Created by Adnan Bhatti on 22/03/2025.
//

import UIKit
import SuperwallKit

class OnboardingFiveViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tryForFreePressed(_ sender: Any) {
        switch Superwall.shared.subscriptionStatus {
        case .unknown:
            self.showToast(message: "⏳ Checking subscription status...")

        case .inactive:
            Superwall.shared.register(placement: "onboarding_completed", handler: createPaywallHandler())

        case .active:
            UserDefaultManager.shared.set(true, for: .isSubscribed)
            self.navigateToRoot()
        }
    }

    private func createPaywallHandler() -> PaywallPresentationHandler {
        let handler = PaywallPresentationHandler()

        handler.onPresent { paywallInfo in
            print("✅ Paywall presented with ID: \(paywallInfo.identifier)")
        }

        handler.onSkip { reason in
            switch reason {
            case .noRuleMatch:
                UserDefaultManager.shared.set(true, for: .isSubscribed)
                self.showToast(message: "✅ You're already subscribed. Unlocking feature...")
                self.navigateToRoot()

            case .holdout:
                self.showToast(message: "🚫 You're in a holdout group. No paywall will be shown.")

            case .eventNotFound:
                self.showToast(message: "⚠️ Paywall placement not found. Please contact support.")

            case .noAudienceMatch:
                self.showToast(message: "🚫 You don’t meet the criteria for this offer.")

            case .placementNotFound:
                self.showToast(message: "❌ Invalid placement identifier used.")

            @unknown default:
                self.showToast(message: "❓ Paywall skipped due to unknown reason.")
            }
        }

        handler.onDismiss { _, result in
            switch result {
            case .purchased:
                UserDefaultManager.shared.set(true, for: .isSubscribed)
                self.showToast(message: "🎉 Subscription successful!")
                self.navigateToRoot()

            case .restored:
                UserDefaultManager.shared.set(true, for: .isSubscribed)
                self.showToast(message: "🔄 Subscription restored.")
                self.navigateToRoot()

            case .declined:
                self.showToast(message: "🔒 Paywall closed. Subscription required to proceed.")
            }
        }

        handler.onError { error in
            self.showToast(message: "❌ Failed to show paywall: \(error.localizedDescription)")
        }

        return handler
    }

    private func navigateToRoot() {
        DispatchQueue.main.async {
            Utility.shared.makeDashboardRoot()
        }
    }
}
