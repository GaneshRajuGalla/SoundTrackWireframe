//
//  LastPlayed+CoreDataProperties.swift
//  
//
//  Created by Ajay Rajput on 19/07/23.
//
//

import Foundation
import CoreData


extension LastPlayed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LastPlayed> {
        return NSFetchRequest<LastPlayed>(entityName: "LastPlayed")
    }

    @NSManaged public var minutes: String?
    @NSManaged public var category: String?
    @NSManaged public var subCategory: String?
    @NSManaged public var media: NSObject?
    @NSManaged public var pausedAt: String?

}
