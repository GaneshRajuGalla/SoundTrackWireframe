//
//  ControlCentreManger.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 27/07/23.
//

import Foundation
import UIKit
import MediaPlayer

protocol ControlCentreManagerDelegate
{
    func playCommand()
    func pauseCommand()
    func nextCommand()
    func previousCommand()
}

class ControlCentreManger : NSObject
{
    
    private var delegate: ControlCentreManagerDelegate? = nil
    private weak var musicView: UIView?
    
    init(delegate: ControlCentreManagerDelegate? = nil,musicView: UIView?) {
        self.delegate = delegate
        self.musicView = musicView
    }
    
    func setupNowPlaying(name: String, elapsedTime: Double, fullDuration: Int, rate: Float) {
#if targetEnvironment(simulator)
        
#else
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = "Zentra"
        nowPlayingInfo[MPMediaItemPropertyArtist] = name
//        Logger.log("Audio total Duration: \(audioPlayer.duration)")
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = fullDuration//minutes * 60
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = rate
        if let image = UIImage.currentAppIcon {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
                return image
            }
        }
        // Set the metadata
        MPNowPlayingInfoCenter.default( ).nowPlayingInfo = nowPlayingInfo
        MPNowPlayingInfoCenter.default().playbackState = .playing
        
        self.setupRemoteCommandCenter()
#endif
    }
    
    func updateNowPlaying(isPause: Bool,seconds: Double? = nil) {
#if targetEnvironment(simulator)
        
#else
        // Define Now Playing Info
        if var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo{
            if let seconds{
                nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seconds
            }
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPause ? 0 : 1
            
            // Set the metadata
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }
#endif

    }
    
    private func setupRemoteCommandCenter() {
#if targetEnvironment(simulator)
        
#else
        let commandCenter = MPRemoteCommandCenter.shared();
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget {event in
            DispatchQueue.main.async {
                
                if let musicView = self.musicView as? MusicPopupView{
                    musicView.playPause(play: true)
                }else{
                    if let musicView = self.musicView as? MusicPopupMixView{
                        musicView.playPause(play: true)
                    }
                }
                
                self.delegate?.playCommand()
            }
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget {event in
            DispatchQueue.main.async {
                if let musicView = self.musicView as? MusicPopupView{
                    musicView.playPause(play: false)
                }else{
                    if let musicView = self.musicView as? MusicPopupMixView{
                        musicView.playPause(play: false)
                    }
                }
                self.delegate?.pauseCommand()
            }
            return .success
        }
        
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget {event in
            
            self.delegate?.nextCommand()
            
            return .success
        }
        
//        commandCenter.previousTrackCommand.isEnabled = true
//        commandCenter.previousTrackCommand.addTarget {event in
//            
//            self.delegate?.previousCommand()
//            
//            return .success
//        }
#endif
    }

    
}
