//
//  MusicPopupView.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 14/06/23.
//

import UIKit

class MusicPopupView: UIView {

    @IBOutlet weak var buttonPlayPause: UIButton!
    @IBOutlet weak var buttonLoop: UIButton!
    
    var playAction: ((Bool) -> Void)?
    var nextAction: (() -> Void)?
    var dislikeAction: (() -> Void)?
    var loopAction: (() -> Void)?
    var isPlaying: Bool = false
    
    @IBAction func btnLoopAction(_ sender: UIButton){
        Haptics.shared.play(.heavy)
        self.loopAction?()
    }
    
    @IBAction func btnNextAction(_ sender: UIButton){
        Haptics.shared.play(.heavy)
        self.nextAction?()
    }
    
    @IBAction func btnPreviousAction(_ sender: UIButton){
        
    }
    
    @IBAction func btnDislikeAction(_ sender: UIButton){
        Haptics.shared.play(.heavy)
        self.dislikeAction?()
    }
    
    @IBAction func btnPlayPauseAction(_ sender: UIButton){
        Haptics.shared.play(.heavy)
        isPlaying = !isPlaying

        self.playPause(play: isPlaying)
    }
    

    func playPause(play: Bool){
        self.isPlaying = play
//        UIView.transition(with: self, duration: 0.3,options: .transitionCrossDissolve) {
        self.buttonPlayPause.setImage(self.isPlaying ? UIImage(named: "pause") : UIImage(named: "play2"), for: .normal)
        playAction?(isPlaying)
    }
}
