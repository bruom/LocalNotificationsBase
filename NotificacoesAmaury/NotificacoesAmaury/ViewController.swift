//
//  ViewController.swift
//  NotificacoesAmaury
//
//  Created by Amaury A V A Souza on 13/06/19.
//  Copyright © 2019 Amaury A V A Souza. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.maximumValue = 10
    }
    
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var titulo: UITextField!
    @IBOutlet weak var badgeNot: UISwitch!
    @IBOutlet weak var som: UISwitch!
    @IBOutlet weak var corpo: UITextField!
    
    @IBAction func stepperValueChaged(_ sender: UIStepper) {
        valueLabel.text = Int(sender.value).description
    }
    
    @IBAction func remindButton(_ sender: UIButton) {
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey : self.titulo.text ?? "deu ruim", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey : self.corpo.text ?? "deu ruim mermo", arguments: nil)
        if self.som.isOn{
            content.sound = UNNotificationSound.default
        }
        if self.badgeNot.isOn{
            content.badge = true
        }
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.stepper.value, repeats: false)
        
        let request = UNNotificationRequest(identifier: "xseconds", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized{
                
             
                center.add(request) { (error: Error?) in
                    if let error = error{
                        print(error.localizedDescription)
                    }
                }
                
                
            }
        }
    }
    
    
}
