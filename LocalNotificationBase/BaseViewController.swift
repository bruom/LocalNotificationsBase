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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func remindButton(_ sender: Any) {
        
        enviarNotificacao(titulo: "Lembre-se 2", corpo: "Corpo", identificador: "1", intervalo: "5", badge: true, som: true)
    }
    
}

