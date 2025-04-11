//
//  ZentraFeatureHighlightsView.swift
//  SoundTrack wireframe
//
//  Created by Kuldeep on 11/04/25.
//

import SwiftUI

struct ZentraBenefitsView: View {
    @State private var titleOpacity: Double = 0
    @State private var titleOffset: CGFloat = -20
    @State private var listOpacity: Double = 0
    @State private var listOffset: CGFloat = -20
    @State private var badgeOpacity: Double = 0
    @State private var badgeOffset: CGFloat = -20
    @State private var buttonOpacity: Double = 0
    @State private var buttonOffset: CGFloat = -20
    @EnvironmentObject var nav: NavigationCoordinator

    private let benefits = [
        "Focus music",
        "Soundscapes",
        "Focus timers",
        "Ad-free, HD music"
    ]

    var body: some View {
        ZStack {
            Image("BG")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            ContentView {
                VStack(spacing: 0) {
                    Text("Here’s what\nyou’ll unlock:")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .opacity(titleOpacity)
                        .offset(y: titleOffset)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(benefits, id: \.self) { item in
                            HStack(alignment: .center, spacing: 8) {
                                Circle()
                                    .foregroundColor(Color("9A9A9A"))
                                    .frame(width: 6, height: 6)
                                Text(item)
                                    .foregroundLinearGradient(
                                        stops: [
                                            .init(color: .white, location: 0),
                                            .init(color: Color("9A9A9A"), location: 1)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .font(.system(size: 24))
                            }
                        }
                    }
                    .opacity(listOpacity)
                    .offset(y: listOffset)
                    
                    Spacer()
                    
                    Image("best_app")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 157, height: 65)
                        .opacity(badgeOpacity)
                        .offset(y: badgeOffset)
                    
                    Spacer()
                    
                    Button {
                        nav.push(ZentraPaywallIntroView())
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
            withAnimation(Animation.easeOut(duration: 0.6).delay(0.0)) {
                titleOpacity = 1
                titleOffset = 0
            }
            withAnimation(Animation.easeOut(duration: 0.6).delay(0.5)) {
                listOpacity = 1
                listOffset = 0
            }
            withAnimation(Animation.easeOut(duration: 0.6).delay(1.0)) {
                badgeOpacity = 1
                badgeOffset = 0
            }
            withAnimation(Animation.easeOut(duration: 0.6).delay(1.5)) {
                buttonOpacity = 1
                buttonOffset = 0
            }
        }
    }
}

#Preview {
    ZentraBenefitsView()
        .environmentObject(NavigationCoordinator())
}
