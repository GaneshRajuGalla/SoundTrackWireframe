//
//  ZentraPaywallIntroView.swift
//  SoundTrack wireframe
//
//  Created by Kuldeep on 11/04/25.
//

import SwiftUI

struct ZentraPaywallIntroView: View {
    @State private var showImage = false
    @State private var showTitle = false
    @State private var showDescription = false
    @State private var showButton = false

    var body: some View {
        ZStack {
            Image("BG")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ContentView {
                VStack(spacing: 70) {
                    if showTitle {
                        Text("We want you to try Zentra for free.")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .transition(.opacity)
                    }
                    
                    if showImage {
                        Image("zentra_paywall")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 207)
                            .transition(.opacity)
                    }
                    
                    if showDescription {
                        Text("Start your 7-day free trial.\nJust $2.49/mo. Cancel anytime.")
                            .foregroundLinearGradient(
                                colors: [Color("9A9A9A"), Color("E5E5E5")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .font(.system(size: 20))
                            .multilineTextAlignment(.center)
                            .transition(.opacity)
                    }
                    
                    Spacer()
                    
                    if showButton {
                        Button {
                            // handle continue action
                        } label: {
                            Text("LET’S GET STARTED")
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .transition(.opacity)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 52)
            }
        }
        .onAppear {
            let baseDelay = 0.3
            let animation = Animation.easeInOut(duration: 0.6)

            DispatchQueue.main.asyncAfter(deadline: .now()) {
                withTransaction(Transaction(animation: animation)) {
                    showTitle = true
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + baseDelay) {
                withTransaction(Transaction(animation: animation)) {
                    showImage = true
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + baseDelay * 2) {
                withTransaction(Transaction(animation: animation)) {
                    showDescription = true
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + baseDelay * 3) {
                withTransaction(Transaction(animation: animation)) {
                    showButton = true
                }
            }
        }
    }
}

#Preview {
    ZentraPaywallIntroView()
}
