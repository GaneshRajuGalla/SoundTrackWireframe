//
//  LiveActivityHandler.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 18/08/23.
//

import SwiftUI
import ActivityKit

@available(iOS 16.2, *)
class LiveActivityHandler
{
    static let sharedInstance = LiveActivityHandler()
    private var activity : Activity<MusicAttributes>? = nil
    private var currentId: String = ""
    
    private init() { }
    
    func startActivity(currentTime: Int, totalMinutes: Int, category: String)
    {
        let attributes = MusicAttributes(appName: "Soundtrack", totalMinutes: totalMinutes, category: category)
        let state = MusicAttributes.MusicStatus(currentTime: currentTime, isPlaying: true)
        let activityContent = ActivityContent(state: state, staleDate: nil)
        
        do {
            activity = try Activity<MusicAttributes>.request(attributes: attributes, content: activityContent,pushType: nil)
            guard let activity else {
                print("Error requesting music Live Activity")
                return
            }
            print("Activity added! \(activity.id)")
        } catch (let error) {
            print("Error requesting music Live Activity \(error.localizedDescription).")
        }
    }
    
    func endActivity()
    {
        let state = MusicAttributes.MusicStatus(currentTime: 0,isPlaying: false)
        let activityContent = ActivityContent(state: state, staleDate: nil)
        Task {
            await activity?.end(activityContent,dismissalPolicy: .immediate)
            
        }
    }
    
    func updateActivity(currentTime: Int? = nil,isPlaying: Bool)
    {
        let state = MusicAttributes.MusicStatus(currentTime: currentTime, isPlaying: isPlaying)
        let activityContent = ActivityContent(state: state, staleDate: nil)
        Task {
            await activity?.update(activityContent)
        }
        
    }
    
    
}
