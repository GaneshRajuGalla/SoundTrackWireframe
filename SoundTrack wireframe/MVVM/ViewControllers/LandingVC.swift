//
//  LandingVC.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 31/05/23.
//

import UIKit

class LandingVC: UIViewController {

    //MARK: Outlets & Properties
    @IBOutlet weak var buttonCross: UIButton!
    
    private let authVm = AuthViewModel()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.buttonCross.isHidden = Utility.shared.appSessionCount > 11
        
    }
    
    //MARK: Button Actions

    @IBAction func btnCrossAction(_ sender: Any) {
        Utility.shared.makeDashboardRoot()
    }
    
    
    @IBAction func bntSocialLoginAction(_ sender: UIButton){
        switch sender.tag{
        case 0 :
            self.loginAppleWithApi()
        case 1:
            self.signInWithGoogle()
        case 2:
            self.signInWithFacebook()
        default:
            break
//           Utility.shared.saveCurrentUserToken("59|VYUaHrnojwbR5kpapDg7lXISUl3SohvtgaZih8LZ")
//            Utility.shared.makeDashboardRoot()
        }
    }
}

//MARK: Social Sign In & API Calls
extension LandingVC{
    private func loginAppleWithApi(){
        self.authVm.signInWithApple {(message) in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
                Utility.shared.makeDashboardRoot()
            }
            
        } fail: {(errMsg) in
            self.showToast(message: errMsg)
        }
    }
    
    
    //MARK:
    private func signInWithGoogle(){
        self.authVm.signInWithGoogle(view: self) {(message) in
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
                Utility.shared.makeDashboardRoot()
            }
            
        } fail: {(errMsg) in
            self.showToast(message: errMsg)
        }
    }
    
    //MARK:
    private func signInWithFacebook(){
        self.authVm.signInWithFacebook(view: self) {(message) in
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
                Utility.shared.makeDashboardRoot()
            }
            
        } fail: {(errMsg) in
            self.showToast(message: errMsg)
        }
    }
}
