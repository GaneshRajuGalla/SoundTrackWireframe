//
//  SountrackError.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 04/08/23.
//

import Foundation


public enum SoundtrackError: Error {
    
    case noMediaFound
    
    
    var localDesc : String {
        get {
            switch self {
            case .noMediaFound:
                return "No media found!\nTry with another category"
            }
        }
    }
    
}
