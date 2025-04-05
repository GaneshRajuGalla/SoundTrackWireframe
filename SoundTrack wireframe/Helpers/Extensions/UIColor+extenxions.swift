//
//  UIColor+extenxions.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 31/05/23.
//

import Foundation
import UIKit

extension UIColor {
    //Conversion from hex color code to UIColor
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
 
    
    static var appDarkBlue : UIColor
    {
        get { return UIColor(named: "AppDarkBlueColor")! }
    }
    
    static var appWhite : UIColor
    {
        get { return UIColor(named: "AppWhiteColor")! }
    }
    
    static var appBlack : UIColor
    {
        get { return UIColor(named: "AppBlackColor")! }
    }
    
    static var appDarkText : UIColor
    {
        get { return UIColor(named: "AppDarkText")! }
    }
    
    
    
}
