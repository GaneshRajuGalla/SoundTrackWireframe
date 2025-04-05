//
//  UIViewController+extension.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 31/05/23.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import SideMenu


enum ScrollDirection
{
    case top
    case bottom
}

extension UIViewController {
    
    //MARK: - ------------------------------------
    static func getVC(_ storyBoard: GlobalProperties.StoryBoardNames) -> Self{
        func instanceFromNib<T : UIViewController>(_ storyBoard : GlobalProperties.StoryBoardNames) -> T{
            guard let vc = controller(storyBoard: storyBoard.rawValue, controller: T.classIdentifier) as? T else{
                fatalError("Not decription")
            }
            return vc
        }
        return instanceFromNib(storyBoard)
    }
    
    static func controller(storyBoard:String, controller:String)->UIViewController{
        
        let storyBoard = UIStoryboard(name: storyBoard, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: controller)
        return vc
    }

    
    
    func pushView(to controller: String,storyboard: GlobalProperties.StoryBoardNames,animated: Bool = true)
    {
        let storyBoard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        let controllerVC = storyBoard.instantiateViewController(withIdentifier: controller)
        self.navigationController?.pushViewController(controllerVC, animated: animated)
    }
 
    func presentView(to controller: String,storyboard: GlobalProperties.StoryBoardNames,animated: Bool = true)
    {
        let storyBoard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        let controllerVC = storyBoard.instantiateViewController(withIdentifier: controller)
        self.present(controllerVC, animated: animated)
    }
    
    func presentViewAsPopup(to controller: String,storyboard: GlobalProperties.StoryBoardNames,animated: Bool = true)
    {
        let storyBoard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        let controllerVC = storyBoard.instantiateViewController(withIdentifier: controller)
        controllerVC.modalPresentationStyle = .overCurrentContext
        controllerVC.modalTransitionStyle = .crossDissolve
        self.present(controllerVC, animated: animated)
    }

    
    func popBack(animated: Bool = true)
    {
        if self.isModal{
            self.dismiss(animated: animated)
        }else{
            self.navigationController?.popViewController(animated: animated)
        }
    }
    
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
    
    func showToast(message: String) {
        let toastHeight: CGFloat = 50
        let toastPaddingTop: CGFloat = UIDevice.current.topNotchSpace
        let toastPadding: CGFloat = 20
        let toastCornerRadius: CGFloat = 10
        
        let toastLabel = UILabel(frame: CGRect(x: toastPadding, y: -toastHeight, width: view.bounds.width - (2 * toastPadding), height: toastHeight))
        
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.layer.cornerRadius = toastCornerRadius
        toastLabel.clipsToBounds = true
        
        // Add a light shadow
        toastLabel.layer.shadowColor = UIColor.lightGray.cgColor
        toastLabel.layer.shadowOpacity = 0.5
        toastLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        toastLabel.layer.shadowRadius = 4
        
        view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            toastLabel.frame.origin.y = toastPaddingTop
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 2, options: .curveEaseIn, animations: {
                toastLabel.frame.origin.y = -toastHeight
            }, completion: { _ in
                toastLabel.removeFromSuperview()
            })
        }
    }
    
    //MARK: - < Open Menu From left side > :
    func openLeftSideMenu(_ animated: Bool = true)
    {
        let sideMenu = SideMenuVC.getVC(.dashBoard)
        let menu = SideMenuNavigationController(rootViewController: sideMenu)
        menu.leftSide = true
        menu.menuWidth = self.view.frame.width*0.75
        menu.presentationStyle = .viewSlideOutMenuZoom
        
        present(menu, animated: animated, completion: nil)
    }
    
    func openRightSideMenu(_ animated: Bool = true)
    {
        let sideMenu = SideMenuVC.getVC(.dashBoard)
        let menu = SideMenuNavigationController(rootViewController: sideMenu)
        menu.leftSide = false
        menu.menuWidth = self.view.frame.width*0.75
        menu.presentationStyle = .viewSlideOutMenuPartialIn
        
        present(menu, animated: animated, completion: nil)
    }
    
    //MARK: ************** Load XIB View *****************
    
    func loadXibView(_ view: UIView, from: ScrollDirection,aboveView: UIView? = nil,height: CGFloat = 85.0)
    {
        view.frame = self.view.bounds
        view.center.y = from == .top ? -1000 : 1500
        if let aboveView{
            self.view.insertSubview(view, aboveSubview: aboveView)
        }else{
            self.view.addSubview(view)
        }
        UIView.animate(withDuration: 0.5) {
            view.frame = CGRect(x: 0, y: (self.view.frame.height-85.0)-24.0, width: self.view.frame.width, height: height)
            self.view.layoutIfNeeded()
        } completion: { (_) in

        }
    }

    func removeXibView(_ view: UIView, with: ScrollDirection,completion: @escaping()->())
    {
        UIView.animate(withDuration: 0.7) {
            view.center.y = with == .top ? -1000 : 1500
            self.view.layoutIfNeeded()
        } completion: { (_) in
            view.removeFromSuperview()
            completion()
        }
    }
    
    //MARK: ***********************************************
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    //To Get if Controlled is Presented Modally:
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
    
    
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return UIWindow.key?.rootViewController?.topMostViewController()
    }
}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
                .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
                .first(where: { $0 is UIWindowScene })
            // Get its associated windows
                .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
                .first(where: \.isKeyWindow)
        } else {
            // Fallback on earlier versions
            return UIApplication.shared.windows.first(where: {$0.isKeyWindow})
        }
    }
}
extension UIDevice {
    /// Returns `true` if the device has a notch
    var hasNotch: Bool {
        guard #available(iOS 11.0, *), let window = UIWindow.key else { return false }
//        print("safeAreaInsets.bottom : ",window.safeAreaInsets.bottom)
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
    
    var bottomNotchSpace: CGFloat {
        get {
            guard #available(iOS 11.0, *), let window = UIWindow.key else { return 20.0 }
            return window.safeAreaInsets.bottom
        }
    }
    
    var topNotchSpace: CGFloat {
        get {
            guard #available(iOS 11.0, *), let window = UIWindow.key else { return 20.0 }
            return window.safeAreaInsets.top
        }
    }

    
}
extension NSObject{
    class var classIdentifier : String{
        return String(describing: self)
    }
}
extension UINavigationController
{
    func popToViewController(viewController: Swift.AnyClass)
    {
        
        if viewControllers.contains(where:{$0.isKind(of: viewController)}){
            for element in viewControllers as Array {
                if element.isKind(of: viewController) {
                    self.popToViewController(element, animated: true)
                    break
                }
            }
        }else{
            popViewController(animated: true)
        }
        
            
    }
}
