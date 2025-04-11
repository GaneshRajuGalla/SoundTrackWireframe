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

    var body: some View {
        ZStack {
            Image("BG")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 70) {
                if showImage {
                    Image("zentra_illustration")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 183)
                        .transition(.opacity)
                }

                if showTitle {
                    Text("Welcome to Zentra")
                        .font(.system(size: 38, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .transition(.opacity)
                }

                if showDescription {
//                    LinearGradient(gradient: Gradient(colors: [Color("9A9A9A"), .white]),
//                                   startPoint: .leading,
//                                   endPoint: .trailing)
//                    .mask(
//                        Text("You’ve made a powerful\ndecision to take control of\nyour focus and productivity.")
//                            .font(.system(size: 20))
//                            .multilineTextAlignment(.center)
//                            .transition(.opacity)
//                    )
                    
                    Text("You’ve made a powerful\ndecision to take control of\nyour focus and productivity.")
                        .font(.system(size: 20))
                        .foregroundColor(Color("9A9A9A"))
                        .multilineTextAlignment(.center)
                        .transition(.opacity)
                }

                Spacer()

                if showButton {
                    Button {
                        // handle continue action
                    } label: {
                        Text("CONTINUE")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color("2A2A2A"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(LinearGradient(gradient: Gradient(colors: [Color("DBF5FF"), Color("E2CAFF")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .cornerRadius(16)
                    }
                    .transition(.opacity)
                }
            }
            .padding(.top, 119)
            .padding(.horizontal)
            .padding(.bottom, 60)
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

extension View {
    func selfSizeMask<T: View>(_ mask: T) -> some View {
        ZStack {
            self.opacity(0)
            mask.mask(self)
        }
    }
}
