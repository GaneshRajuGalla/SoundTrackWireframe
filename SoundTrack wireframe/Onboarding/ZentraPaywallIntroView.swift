//
//  ZentraPaywallIntroView.swift
//  SoundTrack wireframe
//
//  Created by Kuldeep on 11/04/25.
//

import SwiftUI
import SuperwallKit

struct ZentraPaywallIntroView: View {
    @State private var titleOpacity: Double = 0
    @State private var titleOffset: CGFloat = -20
    @State private var imageOpacity: Double = 0
    @State private var imageOffset: CGFloat = -20
    @State private var descriptionOpacity: Double = 0
    @State private var descriptionOffset: CGFloat = -20
    @State private var buttonOpacity: Double = 0
    @State private var buttonOffset: CGFloat = -20
    @EnvironmentObject var nav: NavigationCoordinator

    var body: some View {
        ZStack {
            Image("BG2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ContentView {
                VStack(spacing: 0) {
                    Text("We want you to try Zentra for free.")
                        .font(.custom("KumbhSans-Bold", size: 38))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .opacity(titleOpacity)
                        .offset(y: titleOffset)

                    Spacer()
                    
                    Image("zentra_paywall")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 207)
                        .opacity(imageOpacity)
                        .offset(y: imageOffset)
                    
                    Spacer()
                    
                    Text("Start your 7-day free trial.\nJust $2.49/mo. Cancel anytime.")
                        .foregroundLinearGradient(
                            stops: [
                                .init(color: .white, location: 0),
                                .init(color: Color("9A9A9A"), location: 1)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .font(.system(size: 20))
                        .multilineTextAlignment(.center)
                        .opacity(descriptionOpacity)
                        .offset(y: descriptionOffset)
                    
                    Spacer()
                    
                    Button {
                        getStartedAction()
                    } label: {
                        Text("LET’S GET STARTED")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .opacity(buttonOpacity)
                    .offset(y: buttonOffset)
                }
                .padding(.horizontal, 38)
                .padding(.top, 167)
                .padding(.bottom, 52)
            }
        }
        .onAppear {
            withAnimation(Animation.easeOut(duration: 0.3).delay(0.0)) {
                titleOpacity = 1
                titleOffset = 0
            }
            withAnimation(Animation.easeOut(duration: 0.3).delay(0.2)) {
                imageOpacity = 1
                imageOffset = 0
            }
            withAnimation(Animation.easeOut(duration: 0.3).delay(0.4)) {
                descriptionOpacity = 1
                descriptionOffset = 0
            }
            withAnimation(Animation.easeOut(duration: 0.3).delay(0.6)) {
                buttonOpacity = 1
                buttonOffset = 0
            }
        }
    }
}

extension ZentraPaywallIntroView {
    
    private func getStartedAction() {
        switch Superwall.shared.subscriptionStatus {
        case .unknown:
            self.showToast(message: "⏳ Checking subscription status...")

        case .inactive:
            Superwall.shared.register(placement: "onboarding_completed", handler: createPaywallHandler())

        case .active:
            UserDefaultManager.shared.set(true, for: .isSubscribed)
            navigateToRoot()
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
    
    private func showToast(message: String) {
        if let topVC = UIApplication.shared.topMostViewController() {
            topVC.showToast(message: message)
        }
    }
}

#Preview {
    ZentraPaywallIntroView()
        .environmentObject(NavigationCoordinator())
}
