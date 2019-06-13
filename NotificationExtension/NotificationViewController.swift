//
//  NotificationViewController.swift
//  NotificationExtension
//
//  Created by Lucas Fernandez Nicolau on 13/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    @IBOutlet var bgImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
    }
}
