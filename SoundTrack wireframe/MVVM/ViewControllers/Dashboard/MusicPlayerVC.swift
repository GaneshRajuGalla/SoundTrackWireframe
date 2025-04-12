//
//  MusicPlayerVC.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 09/06/23.
//

import UIKit
import AVFAudio
import AVFoundation
import Lottie

class MusicPlayerVC: UIViewController {
    
    //MARK: Outlets & Properties
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var viewPlayerHolder: UIView!
    @IBOutlet weak var progressView: RAProgressRing!
    @IBOutlet weak var bottomViewConstant: NSLayoutConstraint!
    
    @IBOutlet weak var viewAnimationBack: CustomView!
    @IBOutlet weak var imageAnimation: UIImageView!
    @IBOutlet weak var imageInfinity: UIImageView!
    
    private let musicPopUpView: MusicPopupView = .fromNib()
    lazy var mediaVm = MediaViewModel()
    private var isFullScreen: Bool = false{
        didSet{
            viewFullScreen(show: isFullScreen)
            mediaVm.isFullScreenModel = isFullScreen
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var loader: SpotifyIndicator?
    
    var categorySelected : EmotionTypes = .focus
    var subCategory: String = ""
    var tags: [String] = []
    var minutes: Int = 0
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return isFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpMusicPlayer()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleAnimationViewTap))
        self.viewAnimationBack.addGestureRecognizer(tap)
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0){
            self.showHintPopup()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loadXibView(musicPopUpView, from: .bottom)
        musicPopUpView.playPause(play: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        self.animationView?.frame = imageAnimation.bounds
        //        self.animationView?.center = imageAnimation.center
        self.playerLayer?.frame = imageAnimation.bounds
        self.playerLayer?.contentsCenter = imageAnimation.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.mediaVm.disconnectMusic()
        if Utility.shared.getCurrentUserToken() == ""{
            Utility.shared.appSessionCount += 1
        }
    }
    
    @objc private func handleViewTap(_ sender: UITapGestureRecognizer){
        self.isFullScreen = !isFullScreen
    }
    
    @objc private func handleVideoInBackGround(_ notification: Notification){
        if let isMovingToBackground = notification.object as? Bool{
            if mediaVm.audioPlayer.playerState == .paused{
                self.mediaVm.pauseVideo()
                self.musicPopUpView.playPause(play: false)
                return
            }
            isMovingToBackground ? self.mediaVm.pauseVideo() : self.mediaVm.resumeVideo()
        }
    }
    
    @objc func handleAnimationViewTap(){
        print("Animation View Tapped")
        musicPopUpView.isPlaying = !musicPopUpView.isPlaying
        musicPopUpView.playPause(play: musicPopUpView.isPlaying)
        if musicPopUpView.isPlaying{
            self.mediaVm.resumeMusic()
        }else{
            self.mediaVm.pauseMusic()
        }
        self.mediaVm.updateNowPlaying(isPause: !musicPopUpView.isPlaying)
    }
    
    @IBAction func btnMenuAction(_ sender: Any) {
        self.openRightSideMenu()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton){
        self.mediaVm.disconnectMusic()
        Utility.shared.appSessionCount += 1
        Utility.shared.fireNotification(.backToCategories, object: self.mediaVm, userInfo: [:])
        self.popToSubCategories()
    }
    
    private func setUpMusicPlayer(){
        loader = SpotifyIndicator()
        loader?.yourView = self.view
        loader?.yourViewAlpha = 1
        loader?.show(shape:.circle) // or .square
        
        if minutes == 0{
            //Infinite Time
            labelDuration.isHidden = true
            imageInfinity.isHidden = false
        }
        labelTitle.text = categorySelected.animationName.lowercased()
        viewAnimationBack.backgroundColor = UIColor(hexString: categorySelected.colorHex)
        progressView.circleColor = UIColor(hexString: categorySelected.colorHex)
        configureVideo(with: categorySelected.animationName)
        
        self.mediaVm.delegate = self
        //Configuring View Model
        self.mediaVm.configureWith(categoryName: self.categorySelected.animationName,subCategory: self.subCategory,tags: self.tags,minutes: minutes,holderView: self.viewPlayerHolder,musicView: self.musicPopUpView)
        
        Utility.shared.observeNotification(.movingToBackground, selector: #selector(handleVideoInBackGround(_ :)), view: self)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleViewTap))
        self.viewPlayerHolder.addGestureRecognizer(tap)
        self.addMusicViewAction()
    }
        
    private func configureVideo(with fileUrl: String) {
        guard let videoURL = Bundle.main.url(forResource: fileUrl, withExtension: "mp4") else {
            print("Video file not found.")
            return
        }
        player = AVPlayer(url: videoURL)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        imageAnimation.layer.addSublayer(playerLayer!)
        playerLayer?.frame = imageAnimation.bounds
        
        // Mute the player & play
        player?.isMuted = true
        player?.play()
    }
    
    private func addMusicViewAction(){
        musicPopUpView.playAction = { isPlaying in
            if isPlaying{
                self.mediaVm.resumeMusic()
            }else{
                self.mediaVm.pauseMusic()
            }
            self.mediaVm.updateNowPlaying(isPause: !isPlaying)
        }
        
        musicPopUpView.nextAction = {
            self.mediaVm.playNext()
        }
        
        musicPopUpView.dislikeAction = {
            self.mediaVm.dislikeMedia()
        }
        
        musicPopUpView.loopAction = {
            self.mediaVm.loopMode = !self.mediaVm.loopMode
            let color = self.mediaVm.loopMode ? UIColor(hexString: self.categorySelected.colorHex) : .white.withAlphaComponent(0.35)
            self.musicPopUpView.buttonLoop.tintColor = color//setTitleColor(color, for: .normal)
            self.showToast(message: "Loop track \(self.mediaVm.loopMode ? "enabled" : "disabled")")
        }
    }
    
    private func viewFullScreen(show: Bool){
        UIView.transition(with: view, duration: 0.5,options: .transitionCrossDissolve) {
            [self.viewHeader,
             self.progressView,
             self.viewAnimationBack,
             self.musicPopUpView].forEach({$0?.isHidden = show})
            
            if self.minutes == 0{
                self.imageInfinity.isHidden = show
            }else{
                self.labelDuration.isHidden = show
            }
        }
    }
    
    private func showHintPopup(){
        if Utility.shared.appSessionCount == 0 {
            Utility.shared.displayAlert(title: "Immersive View", message: "Tap the video to toggle Immersive View.", control: "Got it")
        }
    }
}

extension MusicPlayerVC: MediaViewModelDelegates{
    func didFormWaveForm(image: UIImage?){
        DispatchQueue.main.async {
//            self.imageWaves.image = image
        }
    }
    
    func didEndPlaying(error: SoundtrackError?) {
        Logger.log("Fininshed Playing...")
        if let error {
            Utility.shared.displayAlertWithCompletion(title: "", message: error.localDesc, controls: ["Ok"]) { action in
                self.popToSubCategories()
            }
        }else{
            let mainQueue = DispatchQueue.main
            
            mainQueue.async {
                self.mediaVm.disconnectMusic()
                self.labelDuration.text = "00:00"
                Utility.shared.displayAlertWithCompletion(title: "All done", message: "Your session is complete.", controls: ["Done"]) { _ in
                    Utility.shared.appSessionCount += 1
                    if Utility.shared.getCurrentUserToken() == ""{
                        Utility.shared.makeWelcomeRoot()
                    }else{
                        self.popToSubCategories()
                    }
                }
            }
//            mainQueue.async {
//                NotificationManager.sharedInstance.scheduleNotification(title: "Your session is complete.")
//            }
        }
    }
    
    func didUpdateTime(timeRemaining: String, progress: Float) {
        self.labelDuration.text = timeRemaining
//        Logger.log("percentage completed : \(progress)")
        progressView.setProgress(progress, animated: true)
    }
    
    func didChangeStatusTo(_ status: MusicStatus) {
        if status == .startedPlaying{
            DispatchQueue.main.async {
                
                self.loader?.stop()
//                self.loader = nil
            }
        }
    }
    
    private func popToSubCategories(){
        self.navigationController?.popToViewController(viewController: SelectWorkTypeVC.self)
    }
}

