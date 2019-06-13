//
//  editNotification.swift
//  LocalNotificationBase
//
//  Created by Fabrício Guilhermo on 13/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import UserNotifications

func editarNotificacao(_ title:String, _ body:String, _ identifier:String, _ time: TimeInterval, _ notificationBall:NSNumber, _ sound:Bool) -> Void {
    
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.getNotificationSettings { (settings) in
        if settings.authorizationStatus == .authorized {
            
            //                var titulo:String
            //                var conteudo:String
            
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: body, arguments: nil)
            content.sound = UNNotificationSound.default
            
            content.sound = sound ? UNNotificationSound.default : nil
            
            content.badge = notificationBall
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
            
            let request = UNNotificationRequest(identifier: "5seconds", content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error : Error?) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            
        } else {
            print("Impossível mandar notificação - permissão negada")
        }
    }
}
