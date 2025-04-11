//
//  ContentView.swift
//  SoundTrack wireframe
//
//  Created by Kuldeep on 11/04/25.
//

import SwiftUI

struct ContentView<Content: View>: View {
    var content: Content
    var alignment: Axis.Set
    var showsIndicators: Bool
    
    init(alignment: Axis.Set = .vertical, showsIndicators: Bool = true ,@ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.showsIndicators = false
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(alignment, showsIndicators: showsIndicators) {
                content
                    .frame(minHeight: geometry.size.height)
            }
            .frame(width: geometry.size.width)
        }
    }
}
