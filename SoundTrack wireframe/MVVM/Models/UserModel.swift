//
//  UserModel.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 12/06/23.
//

import Foundation

struct UserModel
{
    var name,
        email,
        socialId,
        loginType: String?
    
    init(dict: [String:Any] = [:])
    {
        self.name       = dict["name"] as? String
        self.email      = dict["email"] as? String
        self.socialId   = dict["socialId"] as? String
        self.loginType  = dict["loginType"] as? String
    }
    
}
