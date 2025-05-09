//
//  FocusStruggleTimeView.swift
//  SoundTrack wireframe
//
//  Created by Kuldeep on 11/04/25.
//

import SwiftUI

struct FocusStruggleTimeView: View {
    @State private var selectedTime: String? = nil
    @State private var titleOpacity: Double = 0
    @State private var titleOffset: CGFloat = -20
    @State private var optionsOpacity: Double = 0
    @State private var optionsOffset: CGFloat = -20
    @State private var buttonOpacity: Double = 0
    @State private var buttonOffset: CGFloat = -20
    @EnvironmentObject var nav: NavigationCoordinator

    private let options = [
        "Morning",
        "Afternoon",
        "Evening",
        "All Day"
    ]

    var body: some View {
        ZStack {
            Image("BG2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ContentView {
                VStack(spacing: 0) {
                    Text("When do you struggle\nto focus most?")
                        .font(.custom("KumbhSans-Bold", size: 38))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .opacity(titleOpacity)
                        .offset(y: titleOffset)

                    Spacer()

                    VStack(spacing: 16) {
                        ForEach(options, id: \.self) { option in
                            Button {
                                withAnimation {
                                    selectedTime = option
                                }
                            } label: {
                                Text(option)
                                    .font(.custom("Manrope-Regular", size: 16))
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
                    .opacity(optionsOpacity)
                    .offset(y: optionsOffset)

                    Spacer()

                    Button {
                        nav.push(FocusGoalSelectionView())
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
    FocusStruggleTimeView()
        .environmentObject(NavigationCoordinator())
}
