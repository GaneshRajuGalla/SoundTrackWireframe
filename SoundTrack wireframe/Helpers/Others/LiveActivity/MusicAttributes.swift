//
//  MusicAttributes.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 18/08/23.
//

import Foundation
import ActivityKit
import SwiftUI

struct MusicAttributes: ActivityAttributes
{
    public typealias MusicStatus = ContentState
    
    public struct ContentState: Codable, Hashable
    {
        // Dynamic stateful properties about your activity go here!
        var currentTime: Int?
        var isPlaying: Bool
        var timeRemaining: String? {
            get {
                if let currentTime{
                    let minutes = currentTime / 60
                    let remainingSeconds = currentTime % 60
                    return String(format: "%02d:%02d", minutes, remainingSeconds)
                }
                return "00:00"
            }
        }
    }
    
    var appLogo: String = "app_logo"
    var appName: String
    var totalMinutes: Int
    var category: String

    
}


