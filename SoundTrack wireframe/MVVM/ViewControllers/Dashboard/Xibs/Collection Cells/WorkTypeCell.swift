//
//  WorkTypeCell.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 08/06/23.
//

import UIKit
import AVFoundation

class WorkTypeCell: UICollectionViewCell {

    @IBOutlet weak var viewBack: CustomView!
    @IBOutlet weak var imageType: UIImageView!
    @IBOutlet weak var labelTypeName: UILabel!
    @IBOutlet weak var labelGenreType: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    var index: Int = 0
    var type: String = ""
    var fileUrl : String = ""{
        didSet{
            
            let delaySeconds = Double(self.index + 1) * 0.25
            
            if type == "image" || type == "gif"{
                self.removePlayer()
                if let gifUrl = URL(string: fileUrl),type == "gif"{
                    Utility.shared.downloadGifFile(gifUrl){ gifImage in
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()+delaySeconds){
                            UIView.transition(with: self, duration: 1.0,options: .transitionCrossDissolve) {
                                self.imageType.image = gifImage
                                self.stackView.isHidden = false
//                                self.labelGenreType.isHidden = false
                            }
                        }
                        
                    }
                }else{
                    DispatchQueue.main.asyncAfter(deadline: .now()+delaySeconds){
                        UIView.transition(with: self, duration: 1.0,options: .transitionCrossDissolve) {
                            Utility.shared.setImageWith(url: self.fileUrl, imageView: self.imageType, defaultImage: UIImage())
                            self.stackView.isHidden = false
//                            self.labelGenreType.isHidden = false
                        }
                    }
                }
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now()+delaySeconds){
                    self.configure(with: self.fileUrl)
                    self.stackView.isHidden = false
//                    self.labelGenreType.isHidden = false
                }
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer?.frame = imageType.bounds
        self.playerLayer?.contentsCenter = imageType.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        removePlayer()
    }

    func configure(with fileUrl: String) {
        guard let videoURL = URL(string: fileUrl) else {
            print("Video file not found.")
            return
        }
        player = AVPlayer(url: videoURL)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        playerLayer?.frame = imageType.bounds
        imageType.layer.addSublayer(playerLayer!)
        
        // Mute the player & play
        player?.isMuted = true
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        player?.play()

    }
    
    func removePlayer() {
        player?.pause()
        UIView.transition(with: self, duration: 0.5,options: .transitionCrossDissolve) {
            self.playerLayer?.removeFromSuperlayer()
            self.playerLayer = nil
            self.player = nil
            self.layoutIfNeeded()
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func videoDidFinishPlaying() {
        
    }
}
