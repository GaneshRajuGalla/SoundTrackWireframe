//
//  ZentraTrustView.swift
//  SoundTrack wireframe
//
//  Created by Kuldeep on 11/04/25.
//

import SwiftUI

struct ZentraTrustView: View {
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
                    Text("Trusted by thousands.")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .opacity(titleOpacity)
                        .offset(y: titleOffset)

                    Spacer()
                    
                    Text("89% of users report more effective focus after just one week.")
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
                    
                    Image("best_app")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 157, height: 65)
                        .opacity(imageOpacity)
                        .offset(y: imageOffset)
                        .transition(.opacity)

                    Spacer()
                    
                    Button {
                        nav.push(ZentraBenefitsView())
                    } label: {
                        Text("LET’S GET STARTED")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .opacity(buttonOpacity)
                    .offset(y: buttonOffset)
                }
                .padding(.horizontal, 38)
                .padding(.top, 200)
                .padding(.bottom, 52)
            }
        }
        .onAppear {
            withAnimation(Animation.easeOut(duration: 0.3).delay(0.0)) {
                titleOpacity = 1
                titleOffset = 0
            }
            withAnimation(Animation.easeOut(duration: 0.3).delay(0.2)) {
                descriptionOpacity = 1
                descriptionOffset = 0
            }
            withAnimation(Animation.easeOut(duration: 0.3).delay(0.4)) {
                imageOpacity = 1
                imageOffset = 0
            }
            withAnimation(Animation.easeOut(duration: 0.3).delay(0.6)) {
                buttonOpacity = 1
                buttonOffset = 0
            }
        }
    }
}

extension Text {
    public func foregroundLinearGradient(
        stops: [Gradient.Stop],
        startPoint: UnitPoint,
        endPoint: UnitPoint
    ) -> some View {
        self.overlay(
            LinearGradient(
                gradient: Gradient(stops: stops),
                startPoint: startPoint,
                endPoint: endPoint
            ).mask(self),
            alignment: .center
        )
    }
}

#Preview {
    ZentraTrustView()
        .environmentObject(NavigationCoordinator())
}
