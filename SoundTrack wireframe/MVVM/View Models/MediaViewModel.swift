//
//  MediaViewModel.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 20/06/23.
//

import UIKit
import AVFoundation
import MediaPlayer

protocol MediaViewModelDelegates{
    func didFormWaveForm(image: UIImage?)
    func didEndPlaying(error: SoundtrackError?)
    func didUpdateTime(timeRemaining: String,progress: Float)
    func didChangeStatusTo(_ status: MusicStatus)
}
extension MediaViewModelDelegates  {
    
    func didFormWaveForm(image: UIImage?){}
    func didEndPlaying(error: SoundtrackError?){}
    func didUpdateTime(timeRemaining: String,progress: Float){}
    func didChangeStatusTo(_ status: MusicStatus){}

}
enum MusicStatus
{
    case loading
    case startedPlaying
}
class MediaViewModel: NSObject
{
    
    private var networkCall: NetworkCall!
    private (set) var mediaList: [MediaModel] = []
    
    private lazy var fadeView: UIView = {
        let _view = UIView()
        _view.frame = viewPlayerHolder?.bounds ?? .zero
        _view.backgroundColor = .black.withAlphaComponent(0.5)
        return _view
    }()
    
    private var musicView: UIView?
    private var selectedCategory: String = ""
    private var subCategory: String = ""

    private var videoPlayer = AVQueuePlayer()
    private var videoPlayerLayer = AVPlayerLayer()
    private var playerItems = [AVPlayerItem]()
    private var fadeAnimationLayer: CALayer?
    
    private var tags: [String] = []
    var currentSeconds : Int = 0
    private var minutes : Int = 0
    private var timerCountdown: Timer?
    private var controlCenterManager: ControlCentreManger?
    private var observer: NSKeyValueObservation?
    private var currentPlayingIndex: Int = 0{
        didSet{
            //check if last index then hit media api for next media list
//            if currentPlayingIndex == self.mediaList.count - 1 && (mediaList.count % 3) == 0{
                self.pageNo += 1
                let queue = DispatchQueue(label: "media.load.queue",qos: .background)
//                self.loadMediaWorkItem?.cancel()
                let workItem = DispatchWorkItem{
                    self.getMedia()
                }
                self.loadMediaWorkItem = workItem
                queue.async(execute: workItem)
//            }else{
//                if (mediaList.count % 3) != 0{
//                    currentPlayingIndex = 0
//                }
//            }
        }
    }
    
    private var loadMediaWorkItem : DispatchWorkItem?
    
    private var musicPlayerStatus: MusicStatus = .loading{
        didSet{
            self.delegate?.didChangeStatusTo(musicPlayerStatus)
        }
    }

    var audioPlayer = QueuedAudioPlayer()
    var delegate : MediaViewModelDelegates? = nil
    var pageNo = 1
    var loopMode: Bool = false {
        didSet{
            DispatchQueue.main.async {
                self.audioPlayer.repeatMode = self.loopMode ? .track : .queue
            }
        }
    }
    
    
    var isFullScreenModel: Bool = false{
        didSet{
            UIView.transition(with: self.fadeView, duration: 1.0,options: .transitionCrossDissolve) {
                self.fadeView.isHidden = self.isFullScreenModel
            }
//            DispatchQueue.main.asyncAfter(deadline: .now()+1.0){
//                if !self.videoPlayer.isPlaying {//&& self.audioPlayer.playerState != .paused
//                    self.playVideo()
//                }
//            }
        }
    }
    var viewPlayerHolder: UIView? = nil{
        didSet{
            DispatchQueue.main.async{
                self.playVideo()
            }
        }
    }

    
    func configureWith(categoryName: String = "Focus", subCategory: String, tags: [String],minutes: Int,holderView: UIView? = nil,musicView: MusicPopupView? = nil,media: [MediaModel] = [])
    {
        Logger.log("Configuring new session - Category: \(categoryName), Minutes: \(minutes)")
        Logger.log("Current state - mediaList count: \(mediaList.count), currentPlayingIndex: \(currentPlayingIndex)")
        self.controlCenterManager = ControlCentreManger(delegate: self, musicView: musicView)
        self.tags = tags
        self.viewPlayerHolder = holderView
//        if let view = self.viewPlayerHolder{
//            loader = CircularProgressBarView(frame: .zero)
//            loader?.center = view.center
//        }
        self.minutes = minutes
        if currentSeconds == 0{
            self.currentSeconds = minutes * 60
        }
        self.selectedCategory = categoryName
        self.subCategory = subCategory
        self.musicView = musicView
        /// Get All music Related to ags
        
        if media.count>0{
            self.mediaList = media
            self.startUpdatingMedia()
        }else{
            if self.mediaList.count == 0 {
                self.getMedia()
            }else{
                self.startUpdatingMedia()
            }
        }
    }
    
    func getMedia()
    {
        let params = ["tags":tags, "page": self.pageNo,"limit": 1] as [String : Any]
        
        networkCall = NetworkCall(data: params, headers: Utility.shared.getDefaultHeaders(), service: .media, method: .get,isJSONRequest: false)
        
        networkCall.executeQuery { result in
            if self.pageNo == 1 {
                self.mediaList.removeAll()
            }
            switch  result
            {
            case .success(let value):
                if let response = value as? [String: Any]
                {
                    let statusCode = response["status"] as? Int ?? 0
                    if statusCode == 200
                    {
                        let data = response["data"] as? [String: Any] ?? [:]
                        let dataArr = data["data"] as? [[String: Any]] ?? []
                        var mediaList: [MediaModel] = []
                        
                        dataArr.forEach { link in
                            let obj = MediaModel(dict: link)
                            mediaList.append(obj)
                        }
                        self.arrangeMusicList(music: mediaList)

//                        if mediaList.count > 0 {
//
//                        }else{
//                            self.delegate?.didEndPlaying(error: .noMediaFound)
//                        }
                    }else{
                        self.delegate?.didEndPlaying(error: .noMediaFound)
                    }
                }
            case .failure(let error):
                Logger.log(error.localizedDescription)
            }
        }
        
    }
    
    private func createHistory(subcategory_name: String,name: String, time: Int, captions: [String])
    {
        let params = [
            "name":name,
            "time":time,
            "captions":captions,
            "subcategory_name": subcategory_name
        ] as [String : Any]
        
        networkCall = NetworkCall(data: params, headers: Utility.shared.getDefaultHeaders(), service: .createHistory)
        
        networkCall.executeQuery { result in
            
            switch  result{
                
            case .success(let value):
                Logger.log(value)
                if let response = value as? [String: Any]
                {
                    let statusCode = response["status"] as? Int ?? 0
                    let message = response["message"] as? String ?? ""
                    if statusCode == 200
                    {
                        let data = response["data"] as? [String: Any] ?? [:]
                        Logger.log(message)
                    }else{
                        Logger.log(message)
                    }
                }else{
                    Logger.log(GlobalProperties.AppMessages.somethingWentWrong)
                }
            case .failure(let error):
                Logger.log(error.localizedDescription)
            }
        }
        
    }
    
    private func arrangeMusicList(music: [MediaModel])
    {
        if self.pageNo == 1{
            self.mediaList = music
            if self.mediaList.count == 0{
                self.delegate?.didEndPlaying(error: .noMediaFound)
                return
            }
            self.startUpdatingMedia()
            if Utility.shared.getCurrentUserToken() != ""{
                self.createHistory(subcategory_name: self.subCategory,name: self.selectedCategory, time: self.minutes, captions: self.tags)
            }
            self.currentPlayingIndex += 1
        }else{
            self.mediaList.append(contentsOf: music)
            
            self.addMoreVideosAudios(music: music)
        }
    }
    
    private func startUpdatingMedia(){
        //Start Audio, Video(if available) & LastPlayed
        self.updateLastPlayed(pausedAt: "0")
        
        self.checkAndPlayNext()
    }
    
    private func updateLastPlayed(pausedAt: String){
        if let jsonData = try? JSONEncoder().encode(self.mediaList){
            CoreDataHandler.shared.updateLastPlayed(pausedAt: pausedAt, category: self.selectedCategory, subcategory: self.subCategory, minutes: "\(self.minutes)", media: jsonData)
        }
    }
        
    func getLastPlayed() -> LastPlayed?
    {
        return CoreDataHandler.shared.fetchLastPlayed().first
    }
    
     @objc private func didUpdateCountdown(){
        
        if (self.currentSeconds == 0){
            self.timerCountdown?.invalidate()
            self.timerCountdown = nil
            self.currentPlayingIndex = 0
            self.delegate?.didEndPlaying(error: nil)
            /*self.currentSeconds = minutes * 60
            if Utility.shared.getCurrentUserToken() == ""{
                self.delegate?.didEndPlaying(error: nil)
                return
            }
            self.checkAndPlayNext()*/
        }
        
        self.currentSeconds -= 1
        let timeRemaining = convertSecondsToMinutesSeconds(seconds: self.currentSeconds)
        let progress = Float(Double(self.currentSeconds) / Double(self.minutes * 60))
         
         if self.audioPlayer.duration == 0 { return }
         self.updateNowPlaying(isPause: false,seconds: Double(self.minutes * 60) - Double(self.currentSeconds))
        self.delegate?.didUpdateTime(timeRemaining: timeRemaining, progress: progress)
    }
    
    @objc private func playerDidFinishPlayingVideo()
    {
        if self.currentPlayingIndex == self.mediaList.count - 1  {
            self.currentPlayingIndex += 1
        }
        if let _ = viewPlayerHolder, let currentItem = videoPlayer.currentItem {
                // Seek to the beginning of the current item
                currentItem.seek(to: .zero, completionHandler: nil)
//            Logger.log("playerItems : \(playerItems.count)")
                if let index = playerItems.firstIndex(of: currentItem) {
                    let nextIndex = (index + 1) % playerItems.count

                    if nextIndex == 0 {
                        // Notify when the last video finishes playing
                        DispatchQueue.main.async {
//                            self.addFadeAnimation()
                            UIView.transition(with: self.viewPlayerHolder!, duration: 0.1,options: .transitionCrossDissolve) {
                                self.playVideo()
                            }
                        }
                    }
                }
            }
    }
    
    private func addTimer()
    {
        if minutes == 0{
//            if loopMode {  }
            delegate?.didEndPlaying(error: nil)
        }else{
            if timerCountdown == nil{
                if viewPlayerHolder != nil{
                    self.videoPlayer.play()
                }

                audioPlayer.play()
                timerCountdown = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(didUpdateCountdown), userInfo: nil, repeats: true)
            }
        }
    }
    
    private func convertSecondsToMinutesSeconds(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    private func playAudioInQueue()
    {
        Logger.log("Setting up audio queue - Number of items: \(mediaList.count)")
        self.audioPlayer.clear()
        let allAudios = self.mediaList.compactMap({ URL(string: $0.audio?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") })
        var items = [DefaultAudioItem]()
        
        allAudios.forEach { audioUrl in
            let audioItem = DefaultAudioItem(audioUrl: audioUrl.absoluteString, sourceType: .stream)
    //        let audioItem = DefaultAudioItem(audioUrl: "https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.mp3", sourceType: .stream)
            items.append(audioItem)

        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default,options: [.allowAirPlay,.allowBluetooth])
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        self.audioPlayer.repeatMode = .queue
        self.audioPlayer.add(items: items, playWhenReady: viewPlayerHolder != nil)
//        self.audioPlayer.wrapper
        self.audioPlayer.wrapper.delegate = self
//        if viewPlayerHolder != nil && minutes > 0{
//            self.addTimer()
//        }
    }
    
    private func playVideo(){
        if viewPlayerHolder == nil {
            return
        }
        let allVideos = self.mediaList.compactMap({ $0.video?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) })
        self.playerItems.removeAll()

        playerItems = self.checkChachedVideos(at: allVideos)

        self.videoPlayer = AVQueuePlayer(items: playerItems)

        if let _ = videoPlayerLayer.player{
            self.videoPlayerLayer.player = self.videoPlayer
            self.videoPlayer.play()

        }else{
            self.videoPlayerLayer = AVPlayerLayer(player: self.videoPlayer)
            self.videoPlayerLayer.frame = self.viewPlayerHolder?.bounds ?? .zero
            self.videoPlayerLayer.videoGravity = .resizeAspectFill
            if self.viewPlayerHolder?.layer.sublayers?.contains(self.videoPlayerLayer) ?? false{
                self.videoPlayerLayer.removeFromSuperlayer()
                self.fadeView.removeFromSuperview()
            }
            self.viewPlayerHolder?.layer.insertSublayer(self.videoPlayerLayer, at: 0)
            self.viewPlayerHolder?.addSubview(self.fadeView)
            self.videoPlayer.actionAtItemEnd = .advance
            self.videoPlayer.isMuted = true
            self.videoPlayer.play()
            
            NotificationCenter.default
                .addObserver(self,
                selector: #selector(playerDidFinishPlayingVideo),
                name: .AVPlayerItemDidPlayToEndTime,
                object: nil
            )
        }
    }
    
    private func checkChachedVideos(at URLs: [String]) -> [AVPlayerItem]{
        let allVideos = URLs.compactMap({ URL(string: $0) })
        var cachedVideoURLs = [URL]()
        var items = [AVPlayerItem]()
        
        allVideos.forEach { url in
            let cachedURL = VideoChacheHandler.cachedFileURL(for: url)

            if FileManager.default.fileExists(atPath: cachedURL.path) {
                items.append(AVPlayerItem(url: cachedURL))
                // Track cached video URLs
                if !cachedVideoURLs.contains(cachedURL){
                    cachedVideoURLs.append(cachedURL)
                }
            } else {
                items.append(AVPlayerItem(url: url))
                VideoChacheHandler.cacheVideo(at: url, to: cachedURL)
            }
        }

        return items
    }
    
    private func addFadeAnimation() {
        fadeAnimationLayer?.backgroundColor = UIColor.white.cgColor
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        fadeAnimationLayer?.opacity = 0
        CATransaction.commit()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.fadeAnimationLayer?.removeFromSuperlayer()
        }
    }
    
    private func checkAndPlayNext(){
        let mainQueue = DispatchQueue(label: "play.audio.video.queue", attributes: .concurrent)
        mainQueue.async {
            self.playVideo()
            self.playAudioInQueue()
            self.musicPlayerStatus = .startedPlaying
            let categoryName = self.subCategory == "" ? self.selectedCategory : self.subCategory
            self.controlCenterManager?.setupNowPlaying(name: categoryName, elapsedTime: self.audioPlayer.duration, fullDuration: self.minutes * 60, rate: self.audioPlayer.rate)
//            if #available(iOS 16.2, *) {
//                LiveActivityHandler.sharedInstance.startActivity(currentTime: Int(self.audioPlayer.duration), totalMinutes: self.minutes * 60, category: categoryName)
//            } else {
//                // Fallback on earlier versions
//            }
        }
    }
    
    private func addMoreVideosAudios(music: [MediaModel]){
        if let lastItem = self.playerItems.last{
            let allVideos = music.compactMap({ $0.video?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) })
            let playerItems = self.checkChachedVideos(at: allVideos)

            playerItems.forEach { newItem in
                DispatchQueue.main.async {
                    self.videoPlayer.insert(newItem, after: lastItem)
                    self.playerItems.append(newItem)
                }
            }
        }
        
        let allAudios = music.compactMap({ URL(string: $0.audio?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") })
        var items = [DefaultAudioItem]()
        
        allAudios.forEach { audioUrl in
            let audioItem = DefaultAudioItem(audioUrl: audioUrl.absoluteString, sourceType: .stream)
            items.append(audioItem)
        }
        
        items.forEach { media in
            DispatchQueue.main.async {
                self.audioPlayer.add(item: media)
            }
        }
        
    }
    
    func pauseVideo()
    {
        if viewPlayerHolder != nil{
            self.videoPlayer.pause()
        }
    }
    
    func resumeVideo()
    {
        if viewPlayerHolder != nil{
            self.videoPlayer.play()
        }
    }
    
    func pauseMusic()
    {
        self.pauseVideo()
        if let timerCountdown{
            timerCountdown.invalidate()
            self.timerCountdown = nil
        }
        self.audioPlayer.pause()
    }
    
    func resumeMusic()
    {
        resumeVideo()
        if minutes > 0{
            addTimer()
        }
    }
    
    func playNext()
    {
        audioPlayer.next()
    }
    
    private func playPrevious()
    {
        audioPlayer.previous()
    }
    
    func dislikeMedia(){
        let audioIndex = audioPlayer.currentIndex
        
        if audioIndex == self.audioPlayer.items.count-1{
            Logger.log("Last Song!!")
            return
        }
        
        audioPlayer.next()
        do{
            try audioPlayer.removeItem(at: audioIndex)
        }
        catch{
            print("Error ......")
        }
    }

    func disconnectMusic(){
        Logger.log("Disconnecting music - Starting cleanup")
        if let timerCountdown{
            timerCountdown.invalidate()
            self.timerCountdown = nil
        }
        self.pageNo = 1
        self.videoPlayer.pause()
        self.videoPlayer.replaceCurrentItem(with: nil)
        self.audioPlayer.stop()
        self.audioPlayer.clear()
        self.playerItems.removeAll()
        self.observer = nil
        self.mediaList.removeAll()  // Clear the media list
        self.currentPlayingIndex = 0  // Reset the playing index
        self.currentSeconds = 0  // Reset the timer
        self.loopMode = false  // Reset loop mode
        Logger.log("Disconnecting music - Cleanup complete")
    }
    
    func updateNowPlaying(isPause: Bool,seconds: Double? = nil){
        self.controlCenterManager?.updateNowPlaying(isPause: isPause,seconds: seconds)
//        if #available(iOS 16.2, *) {
//            if let seconds = seconds{
//                LiveActivityHandler.sharedInstance.updateActivity(currentTime: Int(seconds), isPlaying: !isPause)
//            }else{
//                LiveActivityHandler.sharedInstance.updateActivity(isPlaying: !isPause)
//            }
//        } else {
//            // Fallback on earlier versions
//        }
    }
    
    func checkAudioPlayerState() {
        Logger.log("Audio Player State Check:")
        Logger.log("Current Index: \(audioPlayer.currentIndex)")
        Logger.log("Total Items: \(audioPlayer.items.count)")
        Logger.log("Player State: \(audioPlayer.playerState)")
        Logger.log("Repeat Mode: \(audioPlayer.repeatMode)")
        Logger.log("Current Time: \(audioPlayer.currentTime)")
        Logger.log("Duration: \(audioPlayer.duration)")
    }
    
}
//MARK: Music View UI Delegates
extension MediaViewModel : ControlCentreManagerDelegate
{
    func playCommand() {
        self.resumeMusic()
    }
    
    func pauseCommand() {
        self.pauseMusic()
    }
    
    func nextCommand() {
        self.playNext()
    }
    
    func previousCommand() {
        self.playPrevious()
    }
}

//MARK: Audio Player Delegates
extension MediaViewModel: AVPlayerWrapperDelegate{
    func AVWrapper(didChangeState state: AVPlayerWrapperState) {
        Logger.log("Audio state : \(state.rawValue)")
        switch state{
        case .playing:
            if self.minutes > 0{
                self.addTimer()
            }
            self.musicPlayerStatus = .startedPlaying
            let categoryName = subCategory == "" ? selectedCategory : subCategory
            self.controlCenterManager?.setupNowPlaying(name: categoryName, elapsedTime: audioPlayer.duration, fullDuration: minutes * 60, rate: audioPlayer.rate)
        default : break
        }
    }
    
    func AVWrapperItemDidPlayToEndTime() {
        Logger.log("Music Ended - Current index: \(audioPlayer.currentIndex), Total items: \(audioPlayer.items.count)")
    }

    func AVWrapper(secondsElapsed seconds: Double) {
        
//        self.updateNowPlaying(isPause: false,seconds: seconds)
        
    }
    
    func AVWrapper(failedWithError error: Error?) { }
    
    func AVWrapper(seekTo seconds: Double, didFinish: Bool) { }
    
    func AVWrapper(didUpdateDuration duration: Double) { }
    
    func AVWrapper(didReceiveMetadata metadata: [AVTimedMetadataGroup]) { }
    
    func AVWrapper(didChangePlayWhenReady playWhenReady: Bool) {    }
    
    func AVWrapperItemFailedToPlayToEndTime() { }
    
    func AVWrapperItemPlaybackStalled() { }
    
    func AVWrapperDidRecreateAVPlayer() { }
    
}
