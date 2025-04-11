//
//  Text+Extension.swift
//  SoundTrack wireframe
//
//  Created by Kuldeep on 11/04/25.
//
import Foundation
import SwiftUI

extension Text {
    public func foregroundLinearGradient(
        colors: [Color],
        startPoint: UnitPoint,
        endPoint: UnitPoint
    ) -> some View {
        self.overlay(
            LinearGradient(
                colors: colors,
                startPoint: startPoint,
                endPoint: endPoint
            ).mask(self),
            alignment: .center
        )
    }
}
