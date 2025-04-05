//
//  AboutAppVC.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 20/06/23.
//

import UIKit
//import WebKit

enum AboutTypes: String{
    
    case privacyPolicy = "Privacy Policy"
    case termsConditions = "Terms and Conditions"
    
    var slug : String {
        get {
            switch self {
            case .privacyPolicy:
                return "privacy_policy"
            case .termsConditions:
                return "terms_and_conditions"
            }
        }
    }
    
}


class AboutAppVC: UIViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    
    var aboutType: AboutTypes = .privacyPolicy
    private let menuVm = MenuViewModel()
//    private var webView : WKWebView?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        labelTitle.text = aboutType.rawValue
        self.getStaticContent()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.popBack()
    }
}

extension AboutAppVC{
    
//    private func loadWebView()
//    {
//        webView = WKWebView(frame: self.view.bounds)
//        webView?.loadHTMLString(self.menuVm.staticContent, baseURL: nil)
//        self.view.addSubview(webView!)
//        self.view.bringSubviewToFront(webView!)
//    }
    
    private func getStaticContent(){
        self.menuVm.getStaticContent(slug: self.aboutType.slug) { msg in
            self.labelContent.setHTMLText(text: self.menuVm.staticContent as NSString)
//            self.loadWebView()
        } fail: { errMsg in
            Utility.shared.displayAlert(title: "", message: errMsg, control: GlobalProperties.AppMessages.okAction)
        }
    }
}
