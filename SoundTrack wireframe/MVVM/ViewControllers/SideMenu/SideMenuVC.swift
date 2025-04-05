//
//  SideMenuVC.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 15/06/23.
//
//  Updated by Mobass on 3/23/25
//

import UIKit
import SwiftyJSON
import SVProgressHUD

enum MenuOptions : String,CaseIterable{
    case login          = "Sign In"
    case logout         = "Sign Out"
    case contactUs      = "Contact Us"
    case privacyPolicy  = "Privacy"
    case termsCondition = "Terms"
    case delete         = "Delete Account"
}

class SideMenuVC: UIViewController {

    @IBOutlet weak var tableMenu: UITableView!{
        didSet{
            tableMenu.registerNib(cell: SideMenuCell.self)
            tableMenu.delegate = self
            tableMenu.dataSource = self
            
        }
    }
    
    private var menuOptions: [MenuOptions] = MenuOptions.allCases
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Utility.shared.getCurrentUserToken() == ""{
            menuOptions.removeAll(where: {$0 == .logout})
            menuOptions.removeAll(where: {$0 == .delete})
            menuOptions.removeAll(where: {$0 == .contactUs})
        }else{
            menuOptions.removeAll(where: {$0 == .login})
        }
        
        // Add footer view with copyright text
        let footerHeight: CGFloat = 60
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableMenu.frame.width, height: footerHeight))
        footerView.backgroundColor = .clear
        
        let copyrightLabel = UILabel(frame: CGRect(x: 0, y: 60, width: tableMenu.frame.width, height: footerHeight - 20))
        copyrightLabel.text = "© 2025 Mobass"
        copyrightLabel.textColor = .gray
        copyrightLabel.font = UIFont.systemFont(ofSize: 12)
        copyrightLabel.textAlignment = .center
        footerView.addSubview(copyrightLabel)
        
        tableMenu.tableFooterView = footerView
    }
}

extension SideMenuVC: UITableViewDelegate & UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableMenu.dequeueReusableCell(withIdentifier: SideMenuCell.classIdentifier, for: indexPath) as! SideMenuCell
        cell.labelName.text = menuOptions[indexPath.row].rawValue
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if menuOptions[indexPath.row] == .login{
            Utility.shared.makeWelcomeRoot()
        }else if menuOptions[indexPath.row] == .logout{
            Utility.shared.displayAlertWithCompletion(title: "", message: "Are you sure you want to sign out?", controls: ["Logout","Cancel"]) { action in
                if action == "Logout"{
                    Utility.shared.deleteCurrentUserDetails()
                    Utility.shared.makeWelcomeRoot()
                }
            }
        }else if menuOptions[indexPath.row] == .privacyPolicy{
            let vc = AboutAppVC.getVC(.sideMenu)
            vc.aboutType = .privacyPolicy
            self.navigationController?.pushViewController(vc, animated: true)
        }else if menuOptions[indexPath.row] == .termsCondition{
            let vc = AboutAppVC.getVC(.sideMenu)
            vc.aboutType = .termsConditions
            self.navigationController?.pushViewController(vc, animated: true)
        }else if menuOptions[indexPath.row] == .contactUs{
            let vc = ContactUsVC.getVC(.sideMenu)
            self.navigationController?.pushViewController(vc, animated: true)
        }else if menuOptions[indexPath.row] == .delete{
            Utility.shared.displayAlertWithCompletion(title: "", message: "Are you sure you want to delete your account?", controls: ["Delete","Cancel"]) { action in
                if action == "Delete"{
                    self.deleteAccountAPI()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// API Declared
extension SideMenuVC{
    func deleteAccountAPI(){
        let url = Constants.baseUrl+"/delete/account"
        let pram: [String: Any] = ["delete": true]
        APIManager.shared.fetchData(urlString: url, dict: pram, requestType: .post, view: self) { (result) in
            let json = JSON(result)
            let msg = json["message"].stringValue
            if json["status"].intValue == 200{
                Utility.shared.deleteCurrentUserDetails()
                Utility.shared.makeWelcomeRoot()
            }else {
                self.showToast(message: msg)
            }
        } failure: { (msg) in
            self.showToast(message: GlobalProperties.AppMessages.somethingWentWrong)
        }
    }
}

