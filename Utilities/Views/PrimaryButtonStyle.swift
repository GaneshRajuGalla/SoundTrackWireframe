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
            Image(systemName: "arrow.right")
        }
        .font(.system(size: 15, weight: .bold))
        .foregroundColor(Color("2A2A2A"))
        .padding(.horizontal, 20)
        .frame(height: 68)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color("DBF5FF"), Color("E2CAFF")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
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
