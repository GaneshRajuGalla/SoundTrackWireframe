//
//  extension+NSManged.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 20/07/23.
//

import Foundation
import CoreData

func convertToJSONArray(moArray: [NSManagedObject]) -> Any {
    var jsonArray: [[String: Any]] = []
    for item in moArray {
        var dict: [String: Any] = [:]
        for attribute in item.entity.attributesByName {
            //check if value is present, then add key to dictionary so as to avoid the nil value crash
            if let value = item.value(forKey: attribute.key) {
                dict[attribute.key] = value
            }
        }
        jsonArray.append(dict)
    }
    return jsonArray
}
