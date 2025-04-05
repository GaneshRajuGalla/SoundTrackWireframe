//
//  MusicPopupMixView.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 15/06/23.
//

import UIKit

class MusicPopupMixView: UIView {

    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var labelMinutes: UILabel!
    @IBOutlet weak var buttonPlayPause: UIImageView!
    
    var mediaVm = MediaViewModel()
    
    var lastPlayed: LastPlayed?{
        didSet{
            
            guard let lastPlayed else { return }
            
            self.labelCategory.text = lastPlayed.category
            self.labelMinutes.text = "\(lastPlayed.minutes ?? ""):00"
            mediaVm.delegate = self
            guard let media = try? JSONDecoder().decode([MediaModel].self, from: (lastPlayed.media as! NSData) as Data) else {
                Logger.log("No Media!!")
                return
            }
            
            mediaVm.configureWith(categoryName: lastPlayed.category ?? "", subCategory: lastPlayed.subCategory ?? "", tags: [], minutes: Int(lastPlayed.minutes ?? "") ?? 0,media: media)
        }
    }
    private var isPlaying: Bool = false
    var endSessionAction: (() -> Void)?


    @IBAction func btnEndSession(_ sender: Any) {
        Utility.shared.displayAlertWithCompletion(title: "", message: "Are you sure to end this session?", controls: ["Yes","Cancel"]) { action in
            if action == "Yes"{
                self.mediaVm.disconnectMusic()
                self.endSessionAction?()
            }
        }
    }
    
    @IBAction func btnNextAction(_ sender: UIButton){
        self.mediaVm.playNext()
    }
    
    @IBAction func btnPlay(_ sender: Any) {
        Haptics.shared.play(.heavy)
        isPlaying = !isPlaying
        
        self.playPause(play: isPlaying)
        isPlaying ? self.mediaVm.resumeMusic() : self.mediaVm.pauseMusic()
    }
    
    func playPause(play: Bool)
    {
        self.isPlaying = play
//        UIView.transition(with: self, duration: 0.3,options: .transitionCrossDissolve) {
        self.buttonPlayPause.image = self.isPlaying ? UIImage(named: "pause") : UIImage(named: "play")
    }

}
extension MusicPopupMixView : MediaViewModelDelegates{
    func didChangeStatusTo(_ status: MusicStatus) {
        
    }
    
    func didFormWaveForm(image: UIImage?) {
        
    }
    
    func didEndPlaying(error: SoundtrackError?) {
        
    }
    
    func didUpdateTime(timeRemaining: String, progress: Float) {
        self.labelMinutes.text = timeRemaining

    }
    
    
}
