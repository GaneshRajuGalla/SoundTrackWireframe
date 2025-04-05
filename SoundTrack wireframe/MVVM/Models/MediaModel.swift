//
//  MediaModel.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 21/06/23.
//

import Foundation

struct MediaModel: Codable
{
    var audio,
        video,
        label,
        type,
        active:String?
    
    init(dict: [String: Any] = [:]) {
        audio   = dict["audio"] as? String
        video   = dict["video"] as? String
        label   = dict["label"] as? String
        active  = dict["active"] as? String
        type    = dict["type"] as? String
    }
    
    
    func json() -> [String: Any]
    {
        
        let dict = [
            "audio" : audio ?? "",
            "video" : video ?? "",
            "label" : label ?? "",
            "active": active ?? ""
        ]
        
        return  dict.compactMapValues({ $0 })
        
    }
    
}
