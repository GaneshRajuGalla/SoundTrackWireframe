//
//  Haptics.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 04/07/23.
//

import Foundation
import UIKit

class Haptics {
    static let shared = Haptics()
    
    private init() { }

    func play(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }
    
    func notify(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
    }
}
