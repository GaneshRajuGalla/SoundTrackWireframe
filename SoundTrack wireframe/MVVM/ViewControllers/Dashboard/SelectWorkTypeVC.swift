//
//  SelectWorkTypeVC.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 08/06/23.
//

import UIKit
import Lottie
import AVFoundation

class SelectWorkTypeVC: UIViewController {
    
    //MARK: Outlets & Properties

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewPlayNow: CustomView!
    @IBOutlet weak var imageType: UIImageView!
    
    @IBOutlet weak var collectionViewTypes: UICollectionView!{
        didSet{
            collectionViewTypes.registerNib(cell: WorkTypeCell.self)
            collectionViewTypes.delegate = self
            collectionViewTypes.dataSource = self
        }
    }
    var category: EmotionTypes = .focus
    var subcategories: [Categories]?

//    private var animationView: LottieAnimationView?
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var audioPlayer: AudioPlayer?

    private var selectedSubCatIndex: Int = -1{
        didSet{
            self.collectionViewTypes.reloadItems(at: [IndexPath(item: oldValue, section: 0)])
            self.collectionViewTypes.reloadItems(at: [IndexPath(item: self.selectedSubCatIndex, section: 0)])
        }
    }
    
    var isUserSubscribed: Bool = false

    //MARK: App life cycle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        labelTitle.text = category.animationName.lowercased()
        viewPlayNow.backgroundColor = UIColor(hexString: category.colorHex)
        self.configure(with: category.animationName)
        isUserSubscribed = Utility.shared.isPremiumUser()
        showHintPopup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.animationView?.frame = imageType.bounds
//        self.animationView?.center = imageType.center
        self.playerLayer?.frame = imageType.bounds
        self.playerLayer?.contentsCenter = imageType.bounds
    }
    
    
    //MARK: Actions
    @IBAction func btnBackAction(_ sender: UIButton){
        self.popBack()
    }
    
    @IBAction func btnMenuAction(_ sender: Any) {
        self.openRightSideMenu()
    }
    
    @IBAction func btnPlayNowAction(_ sender: UIButton){
        Haptics.shared.play(.heavy)
        self.playDefaultAudioOnce(sound: .SubcategoryDing)
        let vc = SelectTimeDurationVC.getVC(.dashBoard)
        vc.category = self.category
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showHintPopup(){
        if (Utility.shared.appShowFreeMusicPopUp == 0) {
            Utility.shared.displayAlertWithCompletion(title: "Free music", message: "The first section in each category is free, forever!", controls: ["Got it"]) { i in
                if i == "Got it"{
                    Utility.shared.appShowFreeMusicPopUp += 1
                }
            }
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
        player?.play()
    }
    
    private func playDefaultAudioOnce(sound: Sounds){
        audioPlayer = AudioPlayer()
        audioPlayer?.volume = 0.5
        if let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "wav"){
            let defaultItem = DefaultAudioItem(audioUrl: url.path, sourceType: .file)
            audioPlayer?.load(item: defaultItem,playWhenReady: true)
            audioPlayer?.wrapper.delegate = self
        }
    }
    
}
extension SelectWorkTypeVC: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,  UICollectionViewDataSource
{
    //MARK: Collection Delegates and Datasources
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return subcategories?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionViewTypes.dequeueReusableCell(withReuseIdentifier: WorkTypeCell.classIdentifier, for: indexPath) as? WorkTypeCell else{
            return UICollectionViewCell()
        }
        
        guard let subcategories else{ return cell}
                
        cell.labelTypeName.text = subcategories[indexPath.item].name?.uppercased()
        cell.labelGenreType.text = "(\(subcategories[indexPath.item].captions ?? ""))"
        
        let image = subcategories[indexPath.item].image ?? ""
        let type = subcategories[indexPath.item].type ?? ""

        cell.index = indexPath.item
        cell.type = type
        cell.fileUrl = image
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        guard let subcategories else{ return }
        Haptics.shared.play(.rigid)
        if subcategories.count>0{
            if isUserSubscribed{
                let vc = SelectTimeDurationVC.getVC(.dashBoard)
                vc.category = self.category
                vc.subCategory = subcategories[indexPath.item]
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                if (indexPath.row != 0){
                    let vc = SubscriptionVC.getVC(.dashBoard)
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    let vc = SelectTimeDurationVC.getVC(.dashBoard)
                    vc.category = self.category
                    vc.subCategory = subcategories[indexPath.item]
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let squaredSize = (collectionView.frame.width / 2.0) - 10
        return CGSize(width: squaredSize, height: squaredSize + 10)
    }
}

extension SelectWorkTypeVC: AVPlayerWrapperDelegate{
    func AVWrapper(didChangeState state: AVPlayerWrapperState) {
        
    }
    
    func AVWrapper(secondsElapsed seconds: Double) {
        
    }
    
    func AVWrapper(failedWithError error: Error?) {
        
    }
    
    func AVWrapper(seekTo seconds: Double, didFinish: Bool) {
        
    }
    
    func AVWrapper(didUpdateDuration duration: Double) {
        
    }
    
    func AVWrapper(didReceiveMetadata metadata: [AVTimedMetadataGroup]) {
        
    }
    
    func AVWrapper(didChangePlayWhenReady playWhenReady: Bool) {
        
    }
    
    func AVWrapperItemDidPlayToEndTime() {
        self.audioPlayer?.stop()
        self.audioPlayer = nil
    }
    
    func AVWrapperItemFailedToPlayToEndTime() {
        
    }
    
    func AVWrapperItemPlaybackStalled() {
        
    }
    
    func AVWrapperDidRecreateAVPlayer() {
        
    }
}

// MARK: - SUBSCRIPTION DELEGATE
extension SelectWorkTypeVC: SubscriptionViewDelegate {
    func purchaseSuccessfully() {
        Utility.shared.subscribeUser(value: true)
        isUserSubscribed = Utility.shared.isPremiumUser()
    }
    
    func dismissed() {
        
    }
}
