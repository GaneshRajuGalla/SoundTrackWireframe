//
//  UIImage+Extension.swift
//  SoundTrack wireframe
//
//  Created by Kuldeep on 01/05/25.
//

import Foundation
import UIKit

extension UIImage {
    static var currentAppIcon: UIImage? {
        guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? [String],
              let lastIcon = iconFiles.last else {
            return nil
        }
        return UIImage(named: lastIcon)
    }
}
