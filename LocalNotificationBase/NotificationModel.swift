//
//  NotificationModel.swift
//  LocalNotificationBase
//
//  Created by Felipe Petersen on 13/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import Foundation

class NotificationModel {
    var title: String?
    var message: String?
    var time: Double
    var badge: Bool
    var sound: Bool
    
    init(title: String?, message: String?, time: Double, badge: Bool, sound: Bool) {
        if title == nil || title == "" {
            self.title = "Sem titulo"
        }
        if message == nil || message == "" {
            self.message = "Sem mensagem"
        }
        self.time = time
        self.badge = badge
        self.sound = sound
    }
}

