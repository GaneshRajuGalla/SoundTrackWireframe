//
//  FocusGoalSelectionView.swift
//  SoundTrack wireframe
//
//  Created by Kuldeep on 11/04/25.
//

import SwiftUI

struct FocusGoalSelectionView: View {
    @State private var selectedGoal: String? = nil
    @State private var titleOpacity: Double = 0
    @State private var titleOffset: CGFloat = -20
    @State private var optionsOpacity: Double = 0
    @State private var optionsOffset: CGFloat = -20
    @State private var buttonOpacity: Double = 0
    @State private var buttonOffset: CGFloat = -20
    @EnvironmentObject var nav: NavigationCoordinator

    private let options = [
        "Deep Work / Study",
        "Reducing phone distractions",
        "Staying consistent with routines",
        "Managing ADHD",
        "Other"
    ]

    var body: some View {
        ZStack {
            Image("BG2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ContentView {
                VStack(spacing: 0) {
                    Text("What’s your #1 focus\ngoal right now?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .opacity(titleOpacity)
                        .offset(y: titleOffset)

                    Spacer()

                    VStack(spacing: 16) {
                        ForEach(options, id: \.self) { option in
                            Button {
                                withAnimation {
                                    selectedGoal = option
                                }
                            } label: {
                                Text(option)
                                    .font(.system(size: 16, weight: .medium))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(selectedGoal == option ? Color("E0D6FF") : Color.clear)
                                    .foregroundColor(selectedGoal == option ? Color("484848") : .white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 30)
                                            .stroke(Color.white.opacity(0.7), lineWidth: 1)
                                    )
                                    .cornerRadius(30)
                            }
                        }
                    }
                    .opacity(optionsOpacity)
                    .offset(y: optionsOffset)

                    Spacer()

                    Button {
                        nav.push(ZentraTrustView())
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
                optionsOpacity = 1
                optionsOffset = 0
            }
            withAnimation(Animation.easeOut(duration: 0.3).delay(0.4)) {
                buttonOpacity = 1
                buttonOffset = 0
            }
        }
    }
}

#Preview {
    FocusGoalSelectionView()
        .environmentObject(NavigationCoordinator())
}
