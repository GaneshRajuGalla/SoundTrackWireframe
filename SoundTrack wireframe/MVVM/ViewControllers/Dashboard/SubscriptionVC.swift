//
//  SubscriptionVC.swift
//  SoundTrack wireframe
//
//  Created by Naveen Kumar on 08/09/23.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

enum SubscriptionType: Int{
    case monthly = 0
    case yearly = 1
}

protocol SubscriptionViewDelegate{
    func purchaseSuccessfully()
    func dismissed()
}

class SubscriptionVC: UIViewController {

    @IBOutlet weak var vwMonthly: CustomView!
    @IBOutlet weak var vwYearly: CustomView!
    @IBOutlet weak var lblRestore: UILabel!
    
    var IAPType : IAPHelper.IAPSubscriptionTypes = .subsciptionMonthly
    var delegate : SubscriptionViewDelegate? = nil

    var currentSubsType: SubscriptionType = .monthly{
        didSet{
            if currentSubsType.rawValue == 0{
                vwMonthly.borderColor = UIColor.init(named: "AppBorderColor")
                vwYearly.borderColor = UIColor.init(named: "AppLightGray")
            }else {
                vwMonthly.borderColor = UIColor.init(named: "AppLightGray")
                vwYearly.borderColor = UIColor.init(named: "AppBorderColor")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentSubsType = .monthly
        IAPHelper.shared?.delegate = self
        setupLabelTap()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.popBack()
    }

    func setupLabelTap() {
        let lblRestore = UITapGestureRecognizer(target: self, action: #selector(self.lblRestoreTapped(_:)))
        self.lblRestore.isUserInteractionEnabled = true
        self.lblRestore.addGestureRecognizer(lblRestore)
    }
    
    @IBAction func btnMonthlyAction(_ sender: Any) {
       Haptics.shared.play(.rigid)
        currentSubsType = .monthly
    }
    
    @IBAction func btnYearlyAction(_ sender: Any) {
       Haptics.shared.play(.rigid)
        currentSubsType = .yearly
    }
    
    @IBAction func btnContinueAction(_ sender: Any) {
        Haptics.shared.play(.heavy)
        SVProgressHUD.show()
        if (currentSubsType.rawValue == 0){
            IAPType = .subsciptionMonthly
        }else {
            IAPType = .subsciptionYearly
        }
        IAPHelper.shared?.purchase(productID: self.IAPType)
    }
    
    @objc func lblRestoreTapped(_ sender: UITapGestureRecognizer) {
        Haptics.shared.play(.heavy)
        IAPHelper.shared?.restorePurchase()
    }
}

//MARK: IAP DELEGATE
extension SubscriptionVC: InAppPurchaseDelegate{
    func purchaseDidSucceed(plan: IAPPlanResult) {
        SVProgressHUD.dismiss()
        print("transactionId ->",plan.transactionId)
        print("localizedPrice ->",plan.localizedPrice)
        
        if let url = Bundle.main.appStoreReceiptURL,
           let data = try? Data(contentsOf: url) {
            let receiptBase64 = data.base64EncodedString()
            print("receiptBase64 ->",receiptBase64)
            
            if Utility.shared.getCurrentUserToken() != "" {
                // User is logged in, verify on server
                self.buyPurchaseOnServer(receipt: receiptBase64, transactionId: plan.transactionId)
            } else {
                // Store purchase locally
                UserDefaults.standard.set(true, forKey: "isPremiumPurchased")
                UserDefaults.standard.set(receiptBase64, forKey: "premiumReceipt")
                UserDefaults.standard.set(plan.transactionId, forKey: "premiumTransactionId")
                UserDefaults.standard.synchronize()
                
                // Prompt for optional account creation
                Utility.shared.displayAlertWithCompletion(title: "Purchase Successful",
                    message: "Would you like to create an account to sync your premium access across devices?", 
                    controls: ["Create Account", "Maybe Later"]) { action in
                        if action == "Create Account" {
                            Utility.shared.makeWelcomeRoot()
                        } else {
                            self.delegate?.purchaseSuccessfully()
                            self.popBack()
                        }
                }
            }
        } else {
            Utility.shared.showAlert(title: "", msg: "Invalid Receipt!", vwController: self)
        }
    }
    
    func paymentCancelled() {
        SVProgressHUD.dismiss()
    }
    
    func errorAlert(_ errMsg: String) {
        SVProgressHUD.dismiss()
        Utility.shared.showAlert(title: "Oops!", msg: errMsg, vwController: self)
    }
    
    func restoreDidSucceed(_ transactionId: String) {
        if Utility.shared.getCurrentUserToken() != "" {
            // User is logged in, verify on server
            restoreSubscription(status: 1)
        } else {
            // Store restored purchase locally
            UserDefaults.standard.set(true, forKey: "isPremiumPurchased")
            UserDefaults.standard.set(transactionId, forKey: "premiumTransactionId")
            UserDefaults.standard.synchronize()
            
            // Prompt for optional account creation
            Utility.shared.displayAlertWithCompletion(title: "Restore Successful!", 
                message: "Would you like to create an account to sync your premium access across devices?", 
                controls: ["Create Account", "Maybe Later"]) { action in
                    if action == "Create Account" {
                        Utility.shared.makeWelcomeRoot()
                    } else {
                        self.delegate?.purchaseSuccessfully()
                        self.popBack()
                    }
            }
        }
    }
    
    func nothingToRestore() {
        SVProgressHUD.dismiss()
        Utility.shared.showAlert(title: "Oops!", msg: "Restore successful but no subscription found", vwController: self)
    }
}

//MARK: APIs
extension SubscriptionVC{
    func buyPurchaseOnServer(receipt: String, transactionId: String){
        var para: [String: Any] = [String: Any]()
        para["reciept"] = receipt
        para["productId"] = self.IAPType.rawValue
        para["transactionId"] = transactionId

        let url = Constants.baseUrl+"/subscription/ios/verify"
        APIManager.shared.fetchData(urlString: url, dict: para, requestType: .post, view: self) { (result) in
            let json = JSON(result)
            let statusCode = json["status"].intValue
            let msg = json["message"].stringValue
            if (statusCode == 200){
                Utility.shared.displayAlertWithCompletion(title: "Congrats!", message: "Your purchase was successful.", controls: ["Ok"]) { action in
                    if action == "Ok"{
                        self.delegate?.purchaseSuccessfully()
                        self.popBack()
                    }
                }
            }else{
                Utility.shared.showAlert(title: "", msg: msg, vwController: self)
            }
        } failure: { (msg) in
            self.showToast(message: GlobalProperties.AppMessages.somethingWentWrong)
        }
    }
    
    func restoreSubscription(status: Int){
        var para: [String: Any] = [String: Any]()
        para["auto_renew_status"] = status
        
        let url = Constants.baseUrl+"/subscription/ios/restore"
        APIManager.shared.fetchData(urlString: url, dict: para, requestType: .post, view: self) { (result) in
            let json = JSON(result)
            let statusCode = json["status"].intValue
            let msg = json["message"].stringValue
            if (statusCode == 200){
                Utility.shared.displayAlertWithCompletion(title: "Success!", message: "You have restored your plan.", controls: ["Ok"]) { action in
                    if action == "Ok"{
                        self.delegate?.purchaseSuccessfully()
                        self.popBack()
                    }
                }
            }else{
                Utility.shared.showAlert(title: "", msg: msg, vwController: self)
            }
        } failure: { (msg) in
            self.showToast(message: GlobalProperties.AppMessages.somethingWentWrong)
        }
    }
}
