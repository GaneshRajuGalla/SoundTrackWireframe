//
//  SoundFocusBoostView.swift
//  SoundTrack wireframe
//
//  Created by Kuldeep on 11/04/25.
//

import SwiftUI

struct SoundFocusBoostView: View {
    @State private var imageOpacity: Double = 0
    @State private var imageOffset: CGFloat = -20
    @State private var titleOpacity: Double = 0
    @State private var titleOffset: CGFloat = -20
    @State private var descOpacity: Double = 0
    @State private var descOffset: CGFloat = -20
    @State private var buttonOpacity: Double = 0
    @State private var buttonOffset: CGFloat = -20
    @EnvironmentObject var nav: NavigationCoordinator

    var body: some View {
        ZStack {
            Image("BG")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ContentView {
                VStack(spacing: 0) {
                    Text("The right sound\nhelps you focus.")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .opacity(titleOpacity)
                        .offset(y: titleOffset)

                    Spacer()

                    Image("zentra_sound")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 207)
                        .opacity(imageOpacity)
                        .offset(y: imageOffset)

                    Spacer()

                    Text("Research shows the right sound\nfrequencies can boost attention\nand reduce mental fatigue.")
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
                        .opacity(descOpacity)
                        .offset(y: descOffset)

                    Spacer()

                    Button {
                        nav.push(MeetZentraView())
                    } label: {
                        Text("CONTINUE")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .opacity(buttonOpacity)
                    .offset(y: buttonOffset)
                }
                .padding(.horizontal, 38)
                .padding(.top, 150)
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
                descOpacity = 1
                descOffset = 0
            }
            withAnimation(Animation.easeOut(duration: 0.6).delay(1.5)) {
                buttonOpacity = 1
                buttonOffset = 0
            }
        }
    }
}

#Preview {
    SoundFocusBoostView()
        .environmentObject(NavigationCoordinator())
}
