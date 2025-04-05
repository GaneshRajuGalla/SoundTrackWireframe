//
//  Font+extensions.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 23/08/23.
//

import SwiftUI


extension Font {
    enum ManropeFont {
        case bold
        case semibold
        case regular
        case custom(String)
        
        var value: String {
            switch self {
            case .bold:
                return "Manrope-Bold"
            case .semibold:
                return "Manrope-SemiBold"
            case .regular:
                return "Manrope-Regular"
            case .custom(let name):
                return name
            }
        }
    }
    
    static func manrope(_ type: ManropeFont, size: CGFloat = 26) -> Font {
        return .custom(type.value, size: size)
    }
    
}
