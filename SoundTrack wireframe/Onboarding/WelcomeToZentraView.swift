//
//  WelcomeToZentraView.swift
//  SoundTrack wireframe
//
//  Created by Kuldeep on 11/04/25.
//

import SwiftUI

struct WelcomeToZentraView: View {
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
                    Image("zentra_illustration")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 183)
                        .opacity(imageOpacity)
                        .offset(y: imageOffset)
                    
                    Spacer()
                    
                    Text("Welcome to Zentra")
                        .font(.system(size: 37, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .opacity(titleOpacity)
                        .offset(y: titleOffset)
                    
                    Spacer()
                    
                    Text("You’ve made a powerful decision to take control of your focus and productivity.")
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
                        nav.push(FocusChallengeView())
                    } label: {
                        Text("CONTINUE")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .opacity(buttonOpacity)
                    .offset(y: buttonOffset)
                }
                .padding(.horizontal, 38)
                .padding(.top, 199)
                .padding(.bottom, 52)
            }
        }
        .onAppear {
            withAnimation(Animation.easeOut(duration: 0.5).delay(0.0)) {
                imageOpacity = 1
                imageOffset = 0
            }
            withAnimation(Animation.easeOut(duration: 0.5).delay(0.2)) {
                titleOpacity = 1
                titleOffset = 0;
            }
            withAnimation(Animation.easeOut(duration: 0.5).delay(0.4)) {
                descOpacity = 1
                descOffset = 0
            }
            withAnimation(Animation.easeOut(duration: 0.5).delay(0.6)) {
                buttonOpacity = 1
                buttonOffset = 0
            }
        }
    }
}

#Preview {
    WelcomeToZentraView()
        .environmentObject(NavigationCoordinator())
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
