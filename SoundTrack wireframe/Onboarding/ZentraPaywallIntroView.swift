//
//  ZentraPaywallIntroView.swift
//  SoundTrack wireframe
//
//  Created by Kuldeep on 11/04/25.
//

import SwiftUI

struct ZentraPaywallIntroView: View {
    @State private var titleOpacity: Double = 0
    @State private var titleOffset: CGFloat = -20
    @State private var imageOpacity: Double = 0
    @State private var imageOffset: CGFloat = -20
    @State private var descriptionOpacity: Double = 0
    @State private var descriptionOffset: CGFloat = -20
    @State private var buttonOpacity: Double = 0
    @State private var buttonOffset: CGFloat = -20

    var body: some View {
        ZStack {
            Image("BG")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ContentView {
                VStack(spacing: 0) {
                    Text("We want you to try Zentra for free.")
                        .font(.system(size: 32, weight: .bold))
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
                        Utility.shared.makeDashboardRoot()
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
            withAnimation(Animation.easeOut(duration: 0.6).delay(0.0)) {
                titleOpacity = 1
                titleOffset = 0
            }
            withAnimation(Animation.easeOut(duration: 0.6).delay(0.5)) {
                imageOpacity = 1
                imageOffset = 0
            }
            withAnimation(Animation.easeOut(duration: 0.6).delay(1.0)) {
                descriptionOpacity = 1
                descriptionOffset = 0
            }
            withAnimation(Animation.easeOut(duration: 0.6).delay(1.5)) {
                buttonOpacity = 1
                buttonOffset = 0
            }
        }
    }
}

#Preview {
    ZentraPaywallIntroView()
        .environmentObject(NavigationCoordinator())
}
