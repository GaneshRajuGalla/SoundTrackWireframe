//
//  WelcomeToZentraView.swift
//  SoundTrack wireframe
//
//  Created by Kuldeep on 11/04/25.
//

import SwiftUI

struct WelcomeToZentraView: View {
    @State private var showImage = false
    @State private var showTitle = false
    @State private var showDescription = false
    @State private var showButton = false
    @EnvironmentObject var nav: NavigationCoordinator

    var body: some View {
        ZStack {
            Image("BG")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            ContentView {
                VStack(spacing: 0) {
                    if showImage {
                        Image("zentra_illustration")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 183)
                            .transition(.opacity)
                    }
                    
                    Spacer()
                    
                    if showTitle {
                        Text("Welcome to Zentra")
                            .font(.system(size: 38, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .transition(.opacity)
                    }
                    
                    Spacer()
                    
                    if showDescription {
                        Text("You’ve made a powerful\ndecision to take control of\nyour focus and productivity.")
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
                            nav.push(FocusChallengeView())
                        } label: {
                            Text("CONTINUE")
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .transition(.opacity)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 199)
                .padding(.bottom, 52)
            }
        }
        .onAppear {
            let baseDelay = 0.3
            let animation = Animation.easeInOut(duration: 0.6)

            DispatchQueue.main.asyncAfter(deadline: .now()) {
                withTransaction(Transaction(animation: animation)) {
                    showImage = true
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + baseDelay) {
                withTransaction(Transaction(animation: animation)) {
                    showTitle = true
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
    WelcomeToZentraView()
}

import Foundation
import UIKit

class NavigationCoordinator: ObservableObject {
    weak var navigationController: UINavigationController?

    func push<Content: View>(_ view: Content) {
        let vc = UIHostingController(rootView: view.environmentObject(self))
        navigationController?.pushViewController(vc, animated: true)
    }
}
