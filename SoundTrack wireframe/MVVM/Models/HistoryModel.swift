//
//  HistoryModel.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 13/06/23.
//

import Foundation

struct HistoryModel
{
    var id: Int?,
        time,
        userId,
        createdAt,
        subcategoryName,
        name: String?,
        captions:[String]?
    
    init(dict: [String: Any] = [:])
    {
        self.id              = dict["id"] as? Int
        self.time            = dict["time"] as? String
        self.userId          = dict["user_id"] as? String
        self.createdAt       = dict["created_at"] as? String
        self.name            = dict["name"] as? String
        self.subcategoryName = dict["subcategory_name"] as? String
        self.captions        = dict["captions"] as? [String]
    }
    
}
