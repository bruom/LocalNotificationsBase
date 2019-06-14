//
//  ViewController.swift
//  LocalNotificationBase
//
//  Created by Bruno Omella Mainieri on 12/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import UserNotifications

class BaseViewController: UIViewController {
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func remindButton(_ sender: Any) {
//        sendNotificationLocal("Lembre-se", "ocê se lembrou", "5", 5, true, 1)
        self.appDelegate?.scheduleNotification("title", "subtitle", "body", "identifier")
    }
    
}

