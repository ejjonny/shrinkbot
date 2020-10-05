//
//  NotificationManager.swift
//  shrinkbot
//
//  Created by Ethan John on 3/2/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static func setUpRecurringNotification(title: String, body: String, reminder: Reminder, completion: @escaping (Bool) -> Void) {
        
        let components: DateComponents
        guard let date = reminder.timeOfDay else { print("Failed to schedule notification. Reminder date was nil.") ; return }
        guard let id = reminder.uuid?.uuidString else { print("Failed to schedule notification. Reminder uuid nil.") ; return }
        components = Calendar.current.dateComponents([.hour, .minute], from: date)
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { print("There was an issue scheduling a notification"); completion(false) ; return }
            
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "Default"))
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            // Add notification
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("Error scheduling local notification: \((error, error.localizedDescription))")
                    completion(false)
                    return
                }
                UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (requests) in
                    print("Successfully scheduled local notification with id \(request.identifier). \(requests.count) total scheduled.")
                })
                completion(true)
            }
        }
    }
    
    static func removeRecurringNotificationFor(reminder: Reminder, completion: @escaping (Bool) -> Void) {
        guard let uuid = reminder.uuid else { print("There was an issue removing a notification (reminder UUID nil)") ; completion(false) ; return }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [uuid.uuidString])
        print("Successfully removed pending local notification with id \(uuid.uuidString).")
        completion(true)
    }
}
