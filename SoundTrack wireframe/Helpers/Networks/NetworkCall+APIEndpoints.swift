//
//  NetworkCall+APIEndpoints.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 12/06/23.
//

import Foundation

extension NetworkCall
{
    enum APIServices :String
    {
        case login           = "/login"
        case categories      = "/categories"
        case categoriesGuest = "/categories-guest"
        case media           = "/media"
        case createHistory   = "/history"
        case staticPage      = "/page/"
    }
}
