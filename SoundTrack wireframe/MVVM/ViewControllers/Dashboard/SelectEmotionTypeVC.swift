//
//  SelectEmotionTypeVC.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 08/06/23.
//

import UIKit
import AVFoundation
import SwiftyJSON

enum Sounds : String {
    case DefaultAudio
    case HomeDing
    case SubcategoryDing
    case HowLongDing
}

class SelectEmotionTypeVC: UIViewController {

    //MARK: Outlets & Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelTitle: GradientLabel!
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var labelHistory: UIStackView!
    @IBOutlet weak var collectionViewHistory: UICollectionView!{
        didSet{
            collectionViewHistory.registerNib(cell: HistoryCell.self)
            collectionViewHistory.delegate = self
            collectionViewHistory.dataSource = self
        }
    }
    @IBOutlet weak var collectionViewTypes: UICollectionView!{
        didSet{
            collectionViewTypes.registerNib(cell: EmotionTypeCell.self)
            collectionViewTypes.delegate = self
            collectionViewTypes.dataSource = self
        }
    }
    @IBOutlet weak var topConstant: NSLayoutConstraint!
    @IBOutlet weak var collectionTypesHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var bottomPlayHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var labelAnimation: DWAnimatedLabel!
    @IBOutlet weak var labelHistoryTitle: GradientLabel!
    
    private let dashboardVm = DashboardViewModel()
    private let musicPopUpView: MusicPopupMixView = .fromNib()
    private let allEmotionTypes: [EmotionTypes] = EmotionTypes.allCases
    private var audioPlayer: AudioPlayer?
    private var lastPlayed: LastPlayed?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    //MARK: App life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topConstant.constant = self.view.frame.height/6
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePlayerTap(_ :)))
//        self.musicPopUpView.addGestureRecognizer(tapGesture)
        Utility.shared.observeNotification(.sessionFinished, selector: #selector(handleSessionFinished(_ :)), view: self)
//        Utility.shared.observeNotification(.backToCategories, selector: #selector(handleBackActionFromPlayer(_ :)), view: self)
        self.getAllCategories()
        DispatchQueue.main.async {
            self.collectionTypesHeightConstant.constant = self.collectionViewTypes.frame.width
        }
//        self.musicPopUpView.endSessionAction = {
//            self.removeXibView(self.musicPopUpView, with: .bottom) {
//                if let lastPlayed = self.lastPlayed{
//                    CoreDataHandler.shared.deleteLastPlayed(lastPlayed: lastPlayed)
//                    self.lastPlayed = nil
//                }
//            }
//        }
        self.playDefaultAudioOnce(sound: .DefaultAudio)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Check premium status for both logged-in and non-logged-in users
        if Utility.shared.getCurrentUserToken() != "" {
            getUserProfile()
        } else {
            // For non-logged-in users, check local premium status
            Utility.shared.subscribeUser(value: UserDefaults.standard.bool(forKey: "isPremiumPurchased"))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.checkLastPlayed()
        if self.labelHistoryTitle.applyGradientWith(startColor: UIColor(hexString: "EEEEEE").withAlphaComponent(0.64), endColor: UIColor(hexString: "DADADA")) { }
        if labelAnimation.text == ""{
            DispatchQueue.main.async {
                self.addLabelAnimation()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5){
          //  self.presentView(to: SubscriptionVC.classIdentifier, storyboard: .subscription)
        }
    }
    
    //MARK: Actions
    @objc func handleBackActionFromPlayer(_ notification: Notification){
//        self.lastPlayed = CoreDataHandler.shared.fetchLastPlayed().first
        if let value = notification.object as? MediaViewModel{
            DispatchQueue.main.async {
                self.musicPopUpView.playPause(play: self.musicPopUpView.mediaVm.audioPlayer.playerState == .playing)
            }
//            self.musicPopUpView.mediaVm
        }
    }
    
    @objc func handleSessionFinished(_ notification: Notification)
    {
        self.getAllCategories()
    }
    
    @objc func handlePlayerTap(_ sender: UITapGestureRecognizer)
    {
        Haptics.shared.play(.heavy)
        let vc = MusicPlayerVC.getVC(.dashBoard)
        vc.categorySelected = EmotionTypes(rawValue: musicPopUpView.lastPlayed?.category ?? "") ?? .focus
        vc.subCategory = musicPopUpView.lastPlayed?.subCategory ?? ""
        vc.minutes = Int(musicPopUpView.lastPlayed?.minutes ?? "") ?? 0
        vc.mediaVm = musicPopUpView.mediaVm
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnMenuAction(_ sender: Any) {
        self.openRightSideMenu()
    }
    
    private func addLabelAnimation()
    {
        labelAnimation.letterSpace = 1
        labelAnimation.animationType = .fade
        labelAnimation.placeHolderColor = .gray
        labelAnimation.textColor = .gray
        labelAnimation.text = "I WANT TO..."
        labelAnimation.startAnimation(duration: 1.0) { }
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            if self.labelAnimation.applyGradientWith(startColor: UIColor(hexString: "EEEEEE").withAlphaComponent(0.64), endColor: UIColor(hexString: "DADADA")){ }
        }
    }
    
    private func checkLastPlayed()
    {
        if let lastPlayed = CoreDataHandler.shared.fetchLastPlayed().first{
            self.lastPlayed = lastPlayed
            if self.musicPopUpView.lastPlayed == nil{
                self.loadXibView(musicPopUpView, from: .bottom,height: 95)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.7)
            {
                self.musicPopUpView.lastPlayed = lastPlayed
            }
        }else{
            
        }
    }
    
    private func playDefaultAudioOnce(sound: Sounds){
        audioPlayer = AudioPlayer()
        audioPlayer?.volume = 0.3
        if let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "wav"){
            let defaultItem = DefaultAudioItem(audioUrl: url.path, sourceType: .file)
            audioPlayer?.load(item: defaultItem,playWhenReady: true)
            audioPlayer?.wrapper.delegate = self
        }
    }
}
extension SelectEmotionTypeVC: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,  UICollectionViewDataSource
{
    //MARK: Collection Delegates and Datasources
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collectionViewHistory{
            if self.dashboardVm.history.count < 4{
                return 4
            }else{
                return self.dashboardVm.history.count
            }
        }else{
            return allEmotionTypes.count
        }
        
         
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == collectionViewHistory
        {
            guard let cell = collectionViewHistory.dequeueReusableCell(withReuseIdentifier: HistoryCell.classIdentifier, for: indexPath) as? HistoryCell else {
                return UICollectionViewCell()
            }
            cell.clipsToBounds = true
            if indexPath.row < self.dashboardVm.history.count{
                let subCat = self.dashboardVm.history[indexPath.item].subcategoryName ?? ""
                if subCat == ""{
                    cell.labelName.text = self.dashboardVm.history[indexPath.item].name
                }else{
                    cell.labelName.text = subCat
                }
                let categegory = self.dashboardVm.history[indexPath.item].name ?? ""
                if let colorIndex = allEmotionTypes.firstIndex(where: {$0.animationName == categegory}){
                    cell.labelMinutes.textColor = UIColor(hexString: allEmotionTypes[colorIndex].colorHex)
                }
                cell.labelMinutes.text = self.dashboardVm.history[indexPath.item].time
                cell.labelMinutes.isHidden = self.dashboardVm.history[indexPath.item].time == "0"
                cell.imageInfinity.isHidden = self.dashboardVm.history[indexPath.item].time != "0"
            }else{
                cell.labelName.text = ""
                cell.labelMinutes.text = ""
            }
            
            return cell
        }else{
            guard let cell = collectionViewTypes.dequeueReusableCell(withReuseIdentifier: EmotionTypeCell.classIdentifier, for: indexPath) as? EmotionTypeCell else {
                return UICollectionViewCell()
            }
            cell.labelTypeName.text = allEmotionTypes[indexPath.item].animationName.uppercased()
            cell.labelTypeName.letterSpace = 1
            cell.viewBack.cornerRadius = cell.viewBack.frame.height / 4.0
            cell.viewBack.backgroundColor = UIColor(hexString: allEmotionTypes[indexPath.item].colorHex)
            let delayForIndexes = delayForIndex(indexPath.item)
            cell.configure(with: self.allEmotionTypes[indexPath.item].animationName)
            DispatchQueue.main.asyncAfter(deadline: .now()+delayForIndexes) {
                cell.playVideo()
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        //Briefly fade the cell on selection
        Haptics.shared.play(.rigid)

        
        UIView.animate(withDuration: 0.2,
                       animations: {
            //Fade-out
            cell.alpha = 0.7
        }) { (completed) in
            cell.alpha = 1
            if collectionView == self.collectionViewHistory
            {
                if indexPath.row >= self.dashboardVm.history.count{
                    return
                }
                let history = self.dashboardVm.history[indexPath.item]
                let vc = MusicPlayerVC.getVC(.dashBoard)
                vc.categorySelected = EmotionTypes(rawValue: history.name ?? "") ?? .focus
                vc.minutes = Int(history.time ?? "") ?? 0
                vc.tags = history.captions ?? []
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            self.playDefaultAudioOnce(sound: .HomeDing)
            let vc = SelectWorkTypeVC.getVC(.dashBoard)
            vc.category =  self.allEmotionTypes[indexPath.row]
            if indexPath.row < self.dashboardVm.categories.count{
                vc.subcategories = self.dashboardVm.categories[indexPath.row].subcategories
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collectionViewHistory
        {
            return CGSize(width: (collectionViewHistory.frame.width/4)-2.5, height: collectionViewHistory.frame.height)
        }else{
            let squaredSize = (collectionView.frame.width / 2.0) - 10
            return CGSize(width: squaredSize, height: squaredSize)
        }
    }
    
    private func delayForIndex(_ index: Int) -> TimeInterval
    {
        switch index
        {
        case 0 : return 1.0
        case 1 : return 3.0
        case 2 : return 5.0
        case 3 : return 6.5
        default : return 0.0
        }
    }
    
}
extension SelectEmotionTypeVC
{
    //MARK: API Calls

    private func getAllCategories()
    {
        dashboardVm.getAllCategories { [weak self] (message) in
            guard let self = self else {
                return
            }
            self.collectionViewHistory.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now()+1.0){
                // Show/Hide History Views
                self.collectionViewHistory.isHidden = (self.dashboardVm.history.count == 0)
                self.labelHistory.isHidden = self.dashboardVm.history.count == 0
                if (self.dashboardVm.history.count > 0) {//&& self.lastPlayed != nil
//                    self.scrollView.setContentOffset(CGPoint(x: 0, y: 130), animated: true)
                    UIView.animate(withDuration: 0.3) {
                        self.topConstant.constant = 60
                        self.view.layoutIfNeeded()
                    }
                }
            }
        } fail: { errMsg in
            self.showToast(message: errMsg)
        }

    }
    
}
extension SelectEmotionTypeVC: AVPlayerWrapperDelegate{
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

// API Declared
extension SelectEmotionTypeVC{
    func getUserProfile(){
        let url = Constants.baseUrl+"/user/profile"
        APIManager.shared.fetchData(urlString: url, dict: [:], requestType: .get, view: self, isLoaderShown: false) { (result) in
            let json = JSON(result)
            let statusCode = json["status"].intValue
            let msg = json["message"].stringValue
            if (statusCode == 200){
                let isSub = json["data"]["subscription"]["auto_renew_status"].boolValue
                Utility.shared.subscribeUser(value: isSub)
            }else{
                Utility.shared.showAlert(title: "", msg: msg, vwController: self)
            }
        } failure: { (msg) in
            self.showToast(message: GlobalProperties.AppMessages.somethingWentWrong)
        }
    }
}

