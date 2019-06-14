//
//  NotificationViewController.swift
//  Extension
//
//  Created by Zewu Chen on 14/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        if let number = notification.request.content.userInfo["CUSTOM"] as? Int {
        }
    }

}
