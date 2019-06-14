//
//  sendNotification.swift
//  LocalNotificationBase
//
//  Created by Matheus Gois on 13/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import Foundation
import UserNotifications

func sendNotificationLocal(_ title:String, _ body:String, _ identifier: String, _ timeInterval:TimeInterval, _ sound:Bool, _ badge:NSNumber) -> Void{
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.getNotificationSettings { (settings) in
        if settings.authorizationStatus == .authorized {
            
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: body, arguments: nil)
            
            content.sound = sound ? UNNotificationSound.default : nil
            content.badge = badge
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error : Error?) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            
            
            
            //Actions
            let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
            let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Delete", options: [.destructive])
            let category = UNNotificationCategory(identifier: identifier,
                                                  actions: [snoozeAction, deleteAction],
                                                  intentIdentifiers: [],
                                                  options: [])
            
            center.setNotificationCategories([category])
            
            
        } else {
            print("Impossível mandar notificação - permissão negada")
        }
    }
}
