//
//  CoreDataHandler.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 19/07/23.
//

import UIKit
import CoreData

class CoreDataHandler {
    static let shared = CoreDataHandler()
    
    private let managedObjectContext: NSManagedObjectContext
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
    }
    
    private func createLastPlayed(pausedAt: String,category: String, subcategory: String, minutes: String, media: Data) {
        let newLastPlayed = NSEntityDescription.insertNewObject(forEntityName: "LastPlayed", into: managedObjectContext) as! LastPlayed
        
        newLastPlayed.pausedAt = pausedAt
        newLastPlayed.category = category
        newLastPlayed.subCategory = subcategory
        newLastPlayed.minutes = minutes
        newLastPlayed.media = media as NSData
        
        saveContext()
    }
    
    func updateLastPlayed(pausedAt: String, category: String, subcategory: String, minutes: String, media: Data) {
        
        if let lastPlayed = fetchLastPlayed().first{
            lastPlayed.pausedAt = pausedAt
            lastPlayed.category = category
            lastPlayed.subCategory = subcategory
            lastPlayed.minutes = minutes
            lastPlayed.media = media as NSData
        }else{
            self.createLastPlayed(pausedAt: pausedAt, category: category, subcategory: subcategory, minutes: minutes, media: media)
        }
        saveContext()
    }
    
    func deleteLastPlayed(lastPlayed: LastPlayed) {
        managedObjectContext.delete(lastPlayed)
        saveContext()
    }
    
    func fetchLastPlayed() -> [LastPlayed] {
        let fetchRequest: NSFetchRequest<LastPlayed> = LastPlayed.fetchRequest()
        
        do {
            let lastPlayedArray = try managedObjectContext.fetch(fetchRequest)
            Logger.log("lastPlayedArray : \(convertToJSONArray(moArray: lastPlayedArray))")
            return lastPlayedArray
        } catch {
            Logger.log("Error fetching data: \(error)")
            return []
        }
    }
    
    private func saveContext() {
        do {
            try managedObjectContext.save()
            Logger.log("Saved in coredata")
        } catch {
            Logger.log("Error saving context: \(error)")
        }
    }
}
