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
        // Set the Superwall delegate to receive updates on subscription status
        Superwall.shared.delegate = self
    }

    @IBAction func tryForFreePressed(_ sender: Any) {
        // Register the onboarding completion event, which will trigger the paywall
//        #if DEBUG
//        Superwall.shared.register(placement: "campaign_trigger")
//        #endif
        Superwall.shared.register(placement: "onboarding_completed")
    }
}

// MARK: - SuperwallDelegate
extension OnboardingFiveViewController: SuperwallDelegate {

    func subscriptionStatusDidChange(_ status: SubscriptionStatus) {
        switch status {
        case .active:
            // Only if the user has an active subscription (or 7-day trial started)
            // allow navigation to main app
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LandingVC") as! LandingVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .inactive:
            // User hasn't subscribed or started trial, keep them on paywall
            print("User must start free trial to proceed.")
        case .unknown:
            break
        }
    }
}
