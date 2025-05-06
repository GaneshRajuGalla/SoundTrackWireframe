//
//  MeetZentraView.swift
//  SoundTrack wireframe
//
//  Created by Kuldeep on 11/04/25.
//

import SwiftUI

struct MeetZentraView: View {
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
            Image("BG2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ContentView {
                VStack(spacing: 0) {
                    Text("Meet Zentra")
                        .font(.custom("KumbhSans-Bold", size: 38))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .opacity(titleOpacity)
                        .offset(y: titleOffset)

                    Spacer()
                    
                    Image("meet_zentra")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 207)
                        .opacity(imageOpacity)
                        .offset(y: imageOffset)

                    Spacer()
                    
                    Text("Personalized soundscapes and a\nsmart focus timer designed to help\nyou enter flow state—fast.")
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
                        nav.push(FocusStruggleTimeView())
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
            withAnimation(Animation.easeOut(duration: 0.3).delay(0.0)) {
                titleOpacity = 1
                titleOffset = 0
            }
            withAnimation(Animation.easeOut(duration: 0.3).delay(0.2)) {
                imageOpacity = 1
                imageOffset = 0
            }
            withAnimation(Animation.easeOut(duration: 0.3).delay(0.4)) {
                descOpacity = 1
                descOffset = 0
            }
            withAnimation(Animation.easeOut(duration: 0.3).delay(0.6)) {
                buttonOpacity = 1
                buttonOffset = 0
            }
        }
    }
}

#Preview {
    MeetZentraView()
        .environmentObject(NavigationCoordinator())
}
