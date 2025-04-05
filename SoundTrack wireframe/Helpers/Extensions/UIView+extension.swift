//
//  UIView+extension.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 31/05/23.
//

import UIKit
import AVFoundation
//shared helpers

private func html(html:NSString, font:UIFont, color:UIColor) -> NSAttributedString {
    let colorName = colorToHexString(color: color)
    let fontName = font.fontName
    let fontSize = font.pointSize

    let style = "<style>body{color: \(colorName); font-family: '\(fontName)'; font-size:\(fontSize)px;}</style>"
    let htmlString = html.appending(style)
    let d = htmlString.data(using: String.Encoding.utf8)!

    do {
        let attrStr = try NSAttributedString(data:d, options:[.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes:nil)
        return attrStr
    }
    catch {
        return NSAttributedString(string: "")
    }
}

private func colorToHexString(color: UIColor) -> String {
    var r:CGFloat = 0
    var g:CGFloat = 0
    var b:CGFloat = 0
    var a:CGFloat = 0

    color.getRed(&r, green: &g, blue: &b, alpha: &a)

    let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

    return String(format:"#%06x", rgb)
}

extension UILabel {

    @IBInspectable
    var letterSpace: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            }
            else {
                attributedString = NSMutableAttributedString(string: text ?? "")
                text = nil
            }

            attributedString.addAttribute(NSAttributedString.Key.kern,
                                           value: newValue,
                                           range: NSRange(location: 0, length: attributedString.length))

            attributedText = attributedString
        }

        get {
            if let currentLetterSpace = attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            }
            else {
                return 0
            }
        }
    }
}

extension UILabel{
    func setHTMLText(text: NSString?) {
        guard let text = text else {
            attributedText = nil
            return
        }
        
        if font == nil {
            font = UIFont.systemFont(ofSize:UIFont.systemFontSize)
        }
        if textColor == nil {
            textColor = UIColor.black
        }
        
        attributedText = html(html: text, font: font, color: textColor)
    }
    

    func applyGradientWith(startColor: UIColor, endColor: UIColor) -> Bool {
        
        var startColorRed:CGFloat = 0
        var startColorGreen:CGFloat = 0
        var startColorBlue:CGFloat = 0
        var startAlpha:CGFloat = 0
        
        if !startColor.getRed(&startColorRed, green: &startColorGreen, blue: &startColorBlue, alpha: &startAlpha) {
            return false
        }
        
        var endColorRed:CGFloat = 0
        var endColorGreen:CGFloat = 0
        var endColorBlue:CGFloat = 0
        var endAlpha:CGFloat = 0
        
        if !endColor.getRed(&endColorRed, green: &endColorGreen, blue: &endColorBlue, alpha: &endAlpha) {
            return false
        }
        
        let gradientText = self.text ?? ""
        
        let name:NSAttributedString.Key = NSAttributedString.Key.font
        let textSize: CGSize = gradientText.size(withAttributes: [name:self.font!])
        let width:CGFloat = textSize.width
        let height:CGFloat = textSize.height
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return false
        }
        
        UIGraphicsPushContext(context)
        
        let glossGradient:CGGradient?
        let rgbColorspace:CGColorSpace?
        let num_locations:size_t = 2
        let locations:[CGFloat] = [ 0.0, 1.0 ]
        let components:[CGFloat] = [startColorRed, startColorGreen, startColorBlue, startAlpha, endColorRed, endColorGreen, endColorBlue, endAlpha]
        rgbColorspace = CGColorSpaceCreateDeviceRGB()
        glossGradient = CGGradient(colorSpace: rgbColorspace!, colorComponents: components, locations: locations, count: num_locations)
        let topCenter = CGPoint.zero
        let bottomCenter = CGPoint(x: 0, y: textSize.height)
        context.drawLinearGradient(glossGradient!, start: topCenter, end: bottomCenter, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
        
        UIGraphicsPopContext()
        
        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return false
        }
        
        UIGraphicsEndImageContext()
        
        self.textColor = UIColor(patternImage: gradientImage)
        
        return true
    }

    
    
}
extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
extension UIImageView
{
    @IBInspectable var cornerRadius: CGFloat {

      get{
           return layer.cornerRadius
       }
       set {
           layer.cornerRadius = newValue
           layer.masksToBounds = newValue > 0
       }
     }
}
extension UIImage{
    
    static func imageWith(color: UIColor, size: CGSize? = nil) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size?.width ?? 1, height: size?.height ?? 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
