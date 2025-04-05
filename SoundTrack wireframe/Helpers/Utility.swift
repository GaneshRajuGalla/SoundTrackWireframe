//
//  GlobalProperties.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 12/06/23.
//
import Foundation
import UIKit
import Photos
import Kingfisher
import Alamofire

class Utility: NSObject{
    var nav: UINavigationController!

    var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
    
    var appSessionCount: Int {
        get {
            return UserDefaults.standard.value(forKey: GlobalProperties.UserDefaultKeys.sessionCount) as? Int ?? 0
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: GlobalProperties.UserDefaultKeys.sessionCount)
        }
    }
    
    var appShowFreeMusicPopUp: Int {
        get {
            return UserDefaults.standard.value(forKey: GlobalProperties.UserDefaultKeys.freeMusicPopup) as? Int ?? 0
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: GlobalProperties.UserDefaultKeys.freeMusicPopup)
        }
    }
        
    static let shared = Utility()
    
    
    lazy var defaultFormatter : DateFormatter = {
        let _formatter = DateFormatter()
        _formatter.dateFormat = "dd-MM-yyyy"
        return _formatter
    }()
    
    func removeObserver(_ name: NotificationsKeys,view: UIViewController)
    {
        NotificationCenter.default.removeObserver(view, name: NSNotification.Name(name.rawValue), object: nil)
    }
    
    func fireNotification(_ name: NotificationsKeys, object: Any?, userInfo: [AnyHashable: Any])
    {
        NotificationCenter.default.post(name: NSNotification.Name(name.rawValue), object: object, userInfo: userInfo)
    }
    
    func observeNotification(_ name: NotificationsKeys, selector: Selector,view: UIViewController)
    {
        NotificationCenter.default.removeObserver(view, name: NSNotification.Name(name.rawValue), object: nil)
        NotificationCenter.default.addObserver(view, selector: selector, name: NSNotification.Name(name.rawValue), object: nil)
    }
    
    func displayAlert(title: String, message: String, control : String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: control, style: .default, handler: nil)
        alert.addAction(action)
        UIApplication.shared.topMostViewController()?.present(alert, animated: true, completion: nil)
    }
    
    
    func displayAlertWithCompletion(title: String, message: String, controls: [String], completion: @escaping(String)-> Void)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for control in controls{
            let action = UIAlertAction(title: control, style: .default) {(action) in
                completion(control)
            }
            alert.addAction(action)
        }
        
        UIApplication.shared.topMostViewController()?.present(alert, animated: true, completion: nil)
    }
    
    
    func displayActionSheet(title: String, message: String, controls: [String], completion: @escaping(String)-> Void)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for control in controls{
            let action = UIAlertAction(title: control, style: .default) {(action) in
                completion(control)
            }
            alert.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action) in

        }
        alert.popoverPresentationController?.sourceView = UIApplication.shared.topMostViewController()?.view//So that iPads Won't Crash
        alert.addAction(cancelAction)
        
        UIApplication.shared.topMostViewController()?.present(alert, animated: true, completion: nil)
    }
    
    func calculateNumberOfRows(total: Int,rows inOneRow: Int) -> Int
    {///In Case you want to increase collection view height so total will be Array Count and inOneRow will be how many rows it will contain
        if (total % inOneRow == 0)
        {
            return total/inOneRow
        }
        return (total/inOneRow) + 1
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
        
    
//    func getCurrentUserSaved() -> UserModel?
//    {
//        if let userData = checkUserDefaultValue(forKey: Constants.UserDefaultKeys.userDataSaved) as? [String:Any]
//        {
////            Logger.log("UserData: \(userData)")
//            let user = UserModel(userData)
//            return user
//        }
//        return nil
//    }
    
    func saveCurrentUserToken(_ token: String){
        UserDefaults.standard.setValue(token, forKey: GlobalProperties.UserDefaultKeys.userToken)
        UserDefaults.standard.synchronize()
    }
    
    func getCurrentUserToken() -> String{
        return UserDefaults.standard.value(forKey: GlobalProperties.UserDefaultKeys.userToken) as? String  ?? ""

    }
    
    func getDefaultHeaders() -> [String: String]{
        if getCurrentUserToken() == "" {
            return [:]
        }
        return ["Authorization": "Bearer \(self.getCurrentUserToken())"]
    }

    func getCurrentUser()->[String:Any]{
        return UserDefaults.standard.value(forKey: GlobalProperties.UserDefaultKeys.userDataSaved) as? [String:Any] ?? [:]
    }
    
    func saveCurrentUser(_ dict: [String:Any]){
        UserDefaults.standard.setValue(dict.removeNull(), forKey: GlobalProperties.UserDefaultKeys.userDataSaved)
        UserDefaults.standard.synchronize()
    }
    
    func subscribeUser(value: Bool){
        if let user = UserDefaults.standard.value(forKey: GlobalProperties.UserDefaultKeys.userDataSaved) as? [String: Any]{
            var userData = user
            userData["isSubscribed"] = value
            self.saveCurrentUser(userData)
        }
        // Also save to local premium status
        UserDefaults.standard.set(value, forKey: "isPremiumPurchased")
        UserDefaults.standard.synchronize()
    }
    
    func isPremiumUser() -> Bool {
        // First check local purchase
        if UserDefaults.standard.bool(forKey: "isPremiumPurchased") {
            return true
        }
        
        // Then check server-side subscription if logged in
        if getCurrentUserToken() != "" {
            if let user = UserDefaults.standard.value(forKey: GlobalProperties.UserDefaultKeys.userDataSaved) as? [String: Any] {
                return user["isSubscribed"] as? Bool ?? false
            }
        }
        
        return false
    }
    
    func checkUserDefaultValue(forKey: String) -> Any?{
        return UserDefaults.standard.value(forKey: forKey)
    }
    
    func getUsercredetialsSaved() -> (email: String,pass: String){
        if let dict = checkUserDefaultValue(forKey: GlobalProperties.UserDefaultKeys.remeberMe) as? [String:Any]
        {
            let credentials = ((dict["email"] as? String ?? ""),(dict["password"] as? String ?? ""))
            
            return credentials
        }
        return ("","")
    }
    
    func deleteCurrentUserDetails(){
        UserDefaults.standard.removeObject(forKey: GlobalProperties.UserDefaultKeys.userDataSaved)
        UserDefaults.standard.removeObject(forKey: GlobalProperties.UserDefaultKeys.userToken)
        UserDefaults.standard.synchronize()
        
        if let lastPlayed = CoreDataHandler.shared.fetchLastPlayed().first{
            CoreDataHandler.shared.deleteLastPlayed(lastPlayed: lastPlayed)
        }
//        GoogleSignInHandler.shared.signOut()
//        FacebookSignInHelper.shared.signOut()
    }
                
    func isDarkModeEnabled() -> Bool{
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                //print("Dark mode")
                return true
            }else{
                return false
            }
        } else {
            // Fallback on earlier versions
        }
        return false
    }
        
    func stringFromDate(format: String, date: String) -> String{
        let dateformatter = DateFormatter()
        if let convertedDate = defaultFormatter.date(from: date){
            dateformatter.dateFormat = format
            return dateformatter.string(from: convertedDate)
        }
        return ""
    }
    
    func stringFromTimeInterval(format: String, date: Double) -> String{
        let dateformatter = DateFormatter()
        let timeInterval = date
        let convertedDate = Date(timeIntervalSince1970: timeInterval)
        dateformatter.dateFormat = format
        return dateformatter.string(from: convertedDate)
    }
        
    func makeWelcomeRoot(){
        let vc = OnboardingOneViewController.getVC(.main)
        nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        nav.interactivePopGestureRecognizer?.isEnabled = true
        nav.interactivePopGestureRecognizer?.delegate = self
        UIWindow.key?.rootViewController = nav
        UIWindow.key?.makeKeyAndVisible()
    }
    
    func makeDashboardRoot(completion: (() -> Void)? = nil) {
        guard let window = UIWindow.key else { return }
        
        let vc = SelectEmotionTypeVC.getVC(.dashBoard)
        nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        nav.interactivePopGestureRecognizer?.isEnabled = true
        nav.interactivePopGestureRecognizer?.delegate = self
        
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            let oldState: Bool = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            window.rootViewController = self.nav
            UIView.setAnimationsEnabled(oldState)
        }, completion: { (finished: Bool) -> () in
            if (completion != nil) {
                completion!()
            }
        })
        
    }

    func setImageWith(url: String, imageView: UIImageView,defaultImage: UIImage)
    {
        imageView.kf.indicatorType = .activity
        if let imgUrl = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""){
            imageView.kf.setImage(with: imgUrl)
        }else{
            imageView.image = defaultImage
        }
    }
    
    func downloadGifFile(_ url: URL, completion: @escaping (_ imageURL: UIImage) -> () = { (imageURL) in} ) {
        KingfisherManager.shared.retrieveImage(with: url, options: .none, progressBlock: nil) { result in
            switch result{
            case .success(let value):
                let imageUrl = UIImage(ciImage: value.image.ciImage!) //else {
//                    return
                
                completion(imageUrl)
            case .failure(let error):
                    return
            }
        }
    }
    
    func showAlert(title:String,msg:String,vwController:UIViewController){
        let alertCon = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertCon.addAction(alertAction)
        vwController.present(alertCon, animated: true, completion: nil)
    }
}

extension Utility: UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return nav.viewControllers.count > 1
    }
}

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
