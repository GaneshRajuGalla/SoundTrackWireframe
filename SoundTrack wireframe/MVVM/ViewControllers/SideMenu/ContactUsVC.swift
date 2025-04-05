//
//  ContactUsVC.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 20/06/23.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON

class ContactUsVC: UIViewController {

    @IBOutlet weak var tfFullName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfContact: UITextField!
    @IBOutlet weak var vwText: IQTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.popBack()
    }

    @IBAction func btnSubmitAction(_ sender: Any) {
        if tfFullName.text == ""{
            Utility.shared.showAlert(title: "Oops!", msg: "Please enter the fullname", vwController: self)
        }else if tfEmail.text == ""{
            Utility.shared.showAlert(title: "Oops!", msg: "Please enter the email", vwController: self)
        }else if !(tfEmail.text?.isValidEmail() ?? false){
            Utility.shared.showAlert(title: "Oops!", msg: "Please enter the valid email", vwController: self)
        }else if tfContact.text == ""{
            Utility.shared.showAlert(title: "Oops!", msg: "Please enter the contact number", vwController: self)
        }else if vwText.text == ""{
            Utility.shared.showAlert(title: "Oops!", msg: "Please enter the message in description box", vwController: self)
        }else {
            submitAPI()
        }
    }
}

extension ContactUsVC {

    func submitAPI(){
        var para: [String: Any] = [String: Any]()
        para["name"] = tfFullName.text
        para["email"] = tfEmail.text
        para["phoneNumber"] = tfContact.text
        para["description"] = vwText.text

        let url = Constants.baseUrl+"/contact-us"
        APIManager.shared.fetchData(urlString: url, dict: para, requestType: .post, view: self) { (result) in
            let json = JSON(result)
            let statusCode = json["status"].intValue
            let msg = json["message"].stringValue
            if (statusCode == 200){
                Utility.shared.displayAlertWithCompletion(title: "", message: msg, controls: ["Ok"]) { action in
                    if action == "Ok"{
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
