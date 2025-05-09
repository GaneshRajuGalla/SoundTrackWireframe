//
//  PrimaryButtonStyle.swift
//  SoundTrack wireframe
//
//  Created by Kuldeep on 11/04/25.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
            Spacer()
            Image("right-arrow")
        }
        .font(.custom("Manrope-Bold", size: 25))
        .foregroundColor(Color("2A2A2A"))
        .padding(.horizontal, 20)
        .frame(height: 68)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color("E2CAFF"), Color("DBF5FF")]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(20)
    }
}
#if DEBUG
#Preview {
    Button {
        
    } label: {
        Text("Continue")
    }
    .buttonStyle(PrimaryButtonStyle())
    .padding()
}
#endif
