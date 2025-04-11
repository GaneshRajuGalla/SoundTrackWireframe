//
//  MeetZentraView.swift
//  SoundTrack wireframe
//
//  Created by Kuldeep on 11/04/25.
//

import SwiftUI

struct MeetZentraView: View {
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
                    if showTitle {
                        Text("Meet Zentra")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .transition(.opacity)
                    }
                    
                    Spacer()
                    
                    if showImage {
                        Image("meet_zentra")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 207)
                            .transition(.opacity)
                    }
                    
                    Spacer()
                    
                    if showDescription {
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
                            .transition(.opacity)
                    }
                    
                    Spacer()
                    
                    if showButton {
                        Button {
                            nav.push(FocusStruggleTimeView())
                        } label: {
                            Text("CONTINUE")
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .transition(.opacity)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 150)
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
    MeetZentraView()
        .environmentObject(NavigationCoordinator())
}
