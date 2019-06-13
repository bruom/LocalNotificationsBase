//
//  enviarNotificacao.swift
//  LocalNotificationBase
//
//  Created by Tamara Erlij on 13/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import Foundation
import UserNotifications
func enviarNotificacao(titulo:String, corpo:String, identificador:String, intervalo:String , badge:Bool, som:Bool) {
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.getNotificationSettings { (settings) in
        if settings.authorizationStatus == .authorized {
            
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: titulo, arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: corpo, arguments: nil)
            content.sound = som ? UNNotificationSound.default : nil
            content.badge = badge ? 1 : 0
            
            guard let tempo = TimeInterval(intervalo) else { return }
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: tempo, repeats: false)
            
            let request = UNNotificationRequest(identifier: identificador, content: content, trigger: trigger)
            
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
