//
//  FocusStruggleTimeView.swift
//  SoundTrack wireframe
//
//  Created by Kuldeep on 11/04/25.
//

import SwiftUI

struct FocusStruggleTimeView: View {
    @State private var selectedTime: String? = nil
    @State private var showTitle = false
    @State private var showOptions = false
    @State private var showButton = false
    @EnvironmentObject var nav: NavigationCoordinator

    private let options = [
        "Morning",
        "Afternoon",
        "Evening",
        "All Day"
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
                        Text("When do you struggle\nto focus most?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .transition(.opacity)
                    }
                    
                    Spacer()

                    if showOptions {
                        VStack(spacing: 16) {
                            ForEach(options, id: \.self) { option in
                                Button {
                                    withAnimation {
                                        selectedTime = option
                                    }
                                } label: {
                                    Text(option)
                                        .font(.system(size: 16, weight: .medium))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(selectedTime == option ? Color("E0D6FF") : Color.clear)
                                        .foregroundColor(selectedTime == option ? Color("484848") : .white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 30)
                                                .stroke(Color.white.opacity(0.7), lineWidth: 1)
                                        )
                                        .cornerRadius(30)
                                }
                            }
                        }
                        .transition(.opacity)
                        .padding(.top, 10)
                    }

                    Spacer()

                    if showButton {
                        Button {
                            nav.push(FocusGoalSelectionView())
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
                    showOptions = true
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + baseDelay * 2) {
                withTransaction(Transaction(animation: animation)) {
                    showButton = true
                }
            }
        }
    }
}

#Preview {
    FocusStruggleTimeView()
        .environmentObject(NavigationCoordinator())
}
