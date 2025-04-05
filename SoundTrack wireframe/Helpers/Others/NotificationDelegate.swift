//
//  NotificationDelegate.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 18/08/23.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    static let sharedInstance = NotificationManager()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private override init() { }
    
    func userAuthorized() {
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }
    
    func scheduleNotification(title: String) {
        
        let content = UNMutableNotificationContent()
        let userActions = "User Actions"
        
        content.title = "Soundtrack"
        content.body = title
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = userActions
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
//        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
//        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
//        let category = UNNotificationCategory(identifier: userActions,
//                                              actions: [snoozeAction, deleteAction],
//                                              intentIdentifiers: [],
//                                              options: [])
//
//        notificationCenter.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.identifier == "Local Notification" {
            print("Handling notifications with the Local Notification Identifier")
        }
        
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "Snooze":
            print("Snooze")
        case "Delete":
            print("Delete")
        default:
            print("Unknown action")
        }
        completionHandler()
    }
}
