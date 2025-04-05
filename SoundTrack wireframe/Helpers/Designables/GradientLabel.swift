//
//  GradientLabel.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 21/06/23.
//

import UIKit
import CoreText

@IBDesignable
class GradientLabel: UILabel {

    enum GradientDirection: Int {
        case vertical = 0
        case horizontal = 1
        case diagonalUp = 2
        case diagonalDown = 3
    }

    @IBInspectable var topColor: UIColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1) {
        didSet { setNeedsLayout() }
    }

    @IBInspectable var bottomColor: UIColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1) {
        didSet { setNeedsLayout() }
    }

    @IBInspectable var gradientDirectionRawValue: Int {
        get {
            return gradientDirection.rawValue
        }
        set {
            if let direction = GradientDirection(rawValue: newValue) {
                gradientDirection = direction
            }
        }
    }

    var gradientDirection: GradientDirection = .vertical {
        didSet { setNeedsLayout() }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateTextColor()
    }

    private func updateTextColor() {
        let image = UIGraphicsImageRenderer(bounds: bounds).image { context in
            let gradient: CGGradient?

            switch gradientDirection {
            case .vertical:
                gradient = CGGradient(colorsSpace: nil, colors: [topColor.cgColor, bottomColor.cgColor] as CFArray, locations: nil)
            case .horizontal:
                gradient = CGGradient(colorsSpace: nil, colors: [topColor.cgColor, bottomColor.cgColor] as CFArray, locations: nil)
            case .diagonalUp:
                gradient = CGGradient(colorsSpace: nil, colors: [topColor.cgColor, bottomColor.cgColor] as CFArray, locations: nil)
            case .diagonalDown:
                gradient = CGGradient(colorsSpace: nil, colors: [topColor.cgColor, bottomColor.cgColor] as CFArray, locations: nil)
            }

            guard let cgGradient = gradient else { return }

            let startPoint: CGPoint
            let endPoint: CGPoint

            switch gradientDirection {
            case .vertical:
                startPoint = CGPoint(x: bounds.midX, y: bounds.minY)
                endPoint = CGPoint(x: bounds.midX, y: bounds.maxY)
            case .horizontal:
                startPoint = CGPoint(x: bounds.minX, y: bounds.midY)
                endPoint = CGPoint(x: bounds.maxX, y: bounds.midY)
            case .diagonalUp:
                startPoint = bounds.origin
                endPoint = CGPoint(x: bounds.maxX, y: bounds.maxY)
            case .diagonalDown:
                startPoint = CGPoint(x: bounds.minX, y: bounds.maxY)
                endPoint = CGPoint(x: bounds.maxX, y: bounds.minY)
            }

            context.cgContext.drawLinearGradient(cgGradient, start: startPoint, end: endPoint, options: [])
        }

        textColor = UIColor(patternImage: image)
    }
}
