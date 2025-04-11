//
//  ZentraFeatureHighlightsView.swift
//  SoundTrack wireframe
//
//  Created by Kuldeep on 11/04/25.
//

import SwiftUI

struct ZentraBenefitsView: View {
    @State private var showTitle = false
    @State private var showList = false
    @State private var showBadge = false
    @State private var showButton = false
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
                    if showTitle {
                        Text("Here’s what you’ll unlock:")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .transition(.opacity)
                    }
                    
                    Spacer()
                    
                    if showList {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(benefits, id: \.self) { item in
                                HStack(alignment: .center, spacing: 8) {
                                    Circle()
                                        .foregroundColor(Color("9A9A9A"))
                                        .frame(width: 6, height: 6)
                                    Text(item)
                                        .foregroundLinearGradient(
                                            colors: [Color("9A9A9A"), Color("E5E5E5")],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                        .font(.system(size: 24))
                                }
                            }
                        }
                        .transition(.opacity)
                    }
                    
                    Spacer()
                    
                    if showBadge {
                        Image("best_app")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 157, height: 65)
                            .transition(.opacity)
                    }
                    
                    Spacer()
                    
                    if showButton {
                        Button {
                            nav.push(ZentraPaywallIntroView())
                        } label: {
                            Text("LET’S GET STARTED")
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .transition(.opacity)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 200)
                .padding(.bottom, 52)
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
                    showList = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + baseDelay * 2) {
                withTransaction(Transaction(animation: animation)) {
                    showBadge = true
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
    ZentraBenefitsView()
}
