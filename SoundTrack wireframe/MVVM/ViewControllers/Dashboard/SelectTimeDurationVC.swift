//
//  SelectTimeDurationVC.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 09/06/23.
//

import UIKit
import AVFoundation

enum TimeDurationTypes: String, CaseIterable{
    case thirty     = "30"
    case sixty      = "60"
    case ninty      = "90"
    case infinity   = "∞"
}

class SelectTimeDurationVC: UIViewController {

    //MARK: Outlets & Properties
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tableTimeDurations: UITableView!{
        didSet{
            tableTimeDurations.registerNib(cell: HowLongCell.self)
            tableTimeDurations.delegate = self
            tableTimeDurations.dataSource = self
        }
    }
    @IBOutlet weak var labelMinutes: UILabel!
    @IBOutlet weak var imageArrow: UIImageView!
    @IBOutlet weak var textfieldDuration: UITextField!
    @IBOutlet weak var buttonNext: UIButton!
    
    var category: EmotionTypes = .focus
    var subCategory: Categories?
    var hours = 0
    var minutes = 0

    private let durationTypes: [TimeDurationTypes] = TimeDurationTypes.allCases
    private let timePicker = UIPickerView()
    private var minutesArr : [Int] = []
    private var hoursArr : [Int] = []
    private var audioPlayer: AudioPlayer?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUIConfiguration()
    }
    
    private func setUIConfiguration()
    {
        ///Adding 5 Minutes stepper
        for minute in stride(from: 5, to: 1000, by: 5){
            self.minutesArr.append(minute)
        }
        
        (0...12).forEach({hoursArr.append($0)})
        
        labelTitle.text = category.animationName.lowercased()
        
        timePicker.delegate = self
        self.textfieldDuration.inputView = timePicker
        self.textfieldDuration.addTarget(self, action: #selector(handleDurationBegin(_ :)), for: .editingDidBegin)
    }
    
    @objc func handleDurationBegin(_ sender: UITextField)
    {
        if self.textfieldDuration.text == ""{
            self.textfieldDuration.text = "5"
            self.labelMinutes.textColor = (textfieldDuration.text?.count ?? 0 > 0) ? .appWhite : .appDarkText
            self.imageArrow.tintColor = (textfieldDuration.text?.count ?? 0 > 0) ? .appWhite : .appDarkText
        }
    }
    
    @IBAction func btnMenuAction(_ sender: Any) {
        self.openRightSideMenu()
    }

    @IBAction func btnBackAction(_ sender: UIButton)
    {
        self.popBack()
    }

    @IBAction func btnCustomDurationAction(_ sender: Any) {
        var duration = 0
        
        if textfieldDuration.text != ""{
            duration = Int(textfieldDuration.text ?? "") ?? 0
        }else{
            textfieldDuration.becomeFirstResponder()
            return
        }

        Haptics.shared.play(.heavy)
        self.playDefaultAudioOnce(sound: .HowLongDing)

        DispatchQueue.main.asyncAfter(deadline: .now()+0.7){
            self.pushToMusicPlayer(duration: duration)
        }
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
extension SelectTimeDurationVC: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? hoursArr.count : (component == 2 ? minutesArr.count : 1)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? "\(hoursArr[row])" : (component == 1 ? "hour" : (component == 2 ? "\(minutesArr[row])" : "min"))
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0{
            hours = hoursArr[row]
        }else if component == 2{
            minutes = minutesArr[row]
        }
        
        let totalMinutes = (hours * 60) + minutes
        
        self.textfieldDuration.text = "\(totalMinutes)"
        self.labelMinutes.textColor = (textfieldDuration.text?.count ?? 0 > 0) ? .appWhite : .appDarkText
        self.imageArrow.tintColor = (textfieldDuration.text?.count ?? 0 > 0) ? .appWhite : .appDarkText
//        self.buttonNext.isUserInteractionEnabled = (textfieldDuration.text?.count ?? 0 > 0)

    }
    
    private func pushToMusicPlayer(duration : Int)
    {
        let tags = (self.subCategory?.tags ?? "").components(separatedBy: ",")
        let vc = MusicPlayerVC.getVC(.dashBoard)
        vc.subCategory = self.subCategory?.name ?? ""
        vc.minutes = duration
        vc.tags = tags
        vc.categorySelected = self.category
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension SelectTimeDurationVC: UITableViewDelegate, UITableViewDataSource
{
    //MARK: Table Delegates and Datasources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return durationTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HowLongCell.classIdentifier, for: indexPath) as? HowLongCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        if indexPath.row == durationTypes.count - 1{
            cell.imageInfinity.isHidden = false
            cell.labelNumber.text = ""
        }else{
            cell.imageInfinity.isHidden = true
            cell.labelNumber.text = durationTypes[indexPath.row].rawValue
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        Haptics.shared.play(.heavy)
        self.playDefaultAudioOnce(sound: .HowLongDing)
        var duration = 0
        
        if indexPath.row == durationTypes.count - 1{
            duration = 0
        }else{
            duration = Int(durationTypes[indexPath.row].rawValue) ?? 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.7){
            self.pushToMusicPlayer(duration: duration)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90
    }
    
}
extension SelectTimeDurationVC: AVPlayerWrapperDelegate{
    func AVWrapper(didChangeState state: AVPlayerWrapperState) { }
    
    func AVWrapper(secondsElapsed seconds: Double) { }
    
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
