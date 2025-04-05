//
//  Constants.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 31/05/23.
//

import Foundation
import UIKit

//Completions for either success and failure:
typealias ResponseCompletion = (String)->Void

enum AppEnvironment{
    case dev
    case live
    
    var baseUrl : String {
        get {
            switch self {
            case .dev:
                return "http://soundtrack.alcax.com/api"
            case .live:
                return "https://admin.soundtrack-music.app/api"
            }
        }
    }
}

// All App Constant Values
class Constants {
    
    static let appEnvironment : AppEnvironment = .live
    
    static let baseUrl = Constants.appEnvironment.baseUrl
//    static let socketURL = Constants.appEnvironment.socketUrl

//    static let googleAPIKey = "AIzaSyAXLa1NcnbHGim70Xz6GI41RD9mULp6IaA"
    static let googleAuthId = "341875416340-laphur3j714jat05d6hbgah8vc912jsq.apps.googleusercontent.com"
}

