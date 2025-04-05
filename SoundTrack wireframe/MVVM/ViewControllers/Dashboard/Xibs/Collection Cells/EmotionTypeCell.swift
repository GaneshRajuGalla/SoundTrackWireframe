//
//  EmotionTypeCell.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 08/06/23.
//

import UIKit
import Lottie
import AVFoundation

class EmotionTypeCell: UICollectionViewCell {

    @IBOutlet weak var viewBack: CustomView!
    @IBOutlet weak var imageType: UIImageView!
    @IBOutlet weak var labelTypeName: UILabel!
    
    private var animationView: LottieAnimationView?
    var animationName : String = ""
        
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer?.frame = imageType.bounds
        self.playerLayer?.contentsCenter = imageType.bounds
//        self.animationView?.frame = imageType.bounds
//        self.animationView?.center = imageType.center
}
    
    override func prepareForReuse() {
        super.prepareForReuse()
        removePlayer()
    }

    //Add Lottie Animation
    func playAnimation()
    {
        // Start LottieAnimationView with animation name (without extension)
        animationView = .init(name: self.animationName)
        animationView!.frame = imageType.bounds
        // Set animation content mode
        animationView!.contentMode = .scaleAspectFit
        // Set animation loop mode
        animationView!.loopMode = .playOnce
        // Adjust animation speed
        animationView!.animationSpeed = 1.0
        imageType.addSubview(animationView!)
        // Play animation
        animationView!.play()
    }
    
    func removePlayer() {
        player?.pause()
        UIView.transition(with: self, duration: 0.5,options: .transitionCrossDissolve) {
            self.playerLayer?.removeFromSuperlayer()
            self.playerLayer = nil
            self.layoutIfNeeded()
        }
    }
    
    
    func configure(with fileUrl: String) {
        guard let videoURL = Bundle.main.url(forResource: fileUrl, withExtension: "mp4") else {
            print("Video file not found.")
            return
        }
        player = AVPlayer(url: videoURL)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        imageType.layer.addSublayer(playerLayer!)
        playerLayer?.frame = imageType.bounds

        // Mute the player & play
        player?.isMuted = true
//        player?.play()

    }
    
    func playVideo(){
        player?.play()
    }

}
