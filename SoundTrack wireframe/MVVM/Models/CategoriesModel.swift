//
//  CategoriesModel.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 13/06/23.
//

import Foundation

struct Categories
{
    
    var id: Int?,
        name,
        tags,
        image,
        color,
        type,
        captions: String?
    
    var subcategories: [Categories]?
    
    init(dict: [String:Any] = [:])
    {
        self.id         = dict["id"] as? Int
        self.name       = dict["name"] as? String
        self.tags       = dict["tags"] as? String
        self.image      = dict["image"] as? String
        self.color      = dict["color"] as? String
        self.type       = dict["type"] as? String
        self.captions   = dict["captions"] as? String

        var subCats = [Categories]()
        
        if let categories = dict["subcategories"] as? [[String:Any]]{
            categories.forEach { category in
                subCats.append(Categories(dict: category))
            }
            self.subcategories = subCats
        }
    }
    
}

