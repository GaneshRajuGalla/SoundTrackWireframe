//
//  UITabbar+extension.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 31/05/23.
//

import Foundation
import UIKit


extension UITabBarController
{
    
    /**
     Show or hide the tab bar.
     - Parameter hidden: `true` if the bar should be hidden.
     - Parameter animated: `true` if the action should be animated.
     - Parameter transitionCoordinator: An optional `UIViewControllerTransitionCoordinator` to perform the animation
     along side with. For example during a push on a `UINavigationController`.
     */
    func setTabBar(
        hidden: Bool,animated: Bool = true
    ) {
        guard let vc = selectedViewController else { return }
        guard tabBarHidden != hidden else { return }
        
        let frame = self.tabBar.frame
        let height = frame.size.height + UIDevice.current.bottomNotchSpace
        let offsetY = hidden ? height : -height
        
        UIViewPropertyAnimator(duration: animated ? 0.3 : 0, curve: .easeOut) {
            self.tabBar.frame = self.tabBar.frame.offsetBy(dx: 0, dy: offsetY)
            self.selectedViewController?.view.frame = CGRect(
                x: 0,
                y: 0,
                width: vc.view.frame.width,
                height: vc.view.frame.height + offsetY
            )
            
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
        }
        .startAnimation()
    }
    
    /// `true` if the tab bar is currently hidden.
    private var tabBarHidden: Bool {
        tabBar.frame.origin.y >= UIScreen.main.bounds.height
    }
    
}
class CustomTabBar : UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        guard let window = UIApplication.shared.keyWindow else {
            return super.sizeThatFits(size)
        }
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 50 + window.safeAreaInsets.bottom
        return sizeThatFits
    }
}
