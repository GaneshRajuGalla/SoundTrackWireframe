//
//  GlobalProperties.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 31/05/23.
//

import Foundation

class GlobalProperties
{
    static var fcmToken: String = ""

    struct AppMessages
    {
        static let somethingWentWrong       = "Something went wrong please try again in sometime!"
        static let noInternetMsg            = "Please check your internet connection and try again!"
        static let noDataFound              = "No data found!"
        static let successMessage           = "Saved Successfuly!"
        static let okAction                 = "Ok"
    }
        
    enum UserDefaultKeys{
        static let userDataSaved           = "USER_DATA"
        static let remeberMe               = "REMEMBER_ME"
        static let userToken               = "USER_TOKEN"
        static let sessionCount            = "APP_SESSION_COUNT"
        static let freeMusicPopup            = "FREE_MUSIC_POPUP"

    }
    
    enum StoryBoardNames: String
    {
        case main               = "Main"
        case dashBoard          = "Dashboard"
        case sideMenu           = "SideMenu"
        case subscription       = "Subscription"
    }

    
}


enum NotificationsKeys: String
{
    case referUrlTapped         = "ReferralUrlTapped"
    case movingToBackground     = "AppMovingToBackground"
    case sessionFinished        = "MusicSessionFinished"
    case backToCategories       = "BackToCategories"
}


class Logger
{
    
    static func log(_ items: Any)
    {
        ///#Developer_Changes (uncomment to debug)
        print(String(describing: items))
    }
    
}
