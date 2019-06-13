//
//  ChallengesTableViewController.swift
//  LocalNotificationBase
//
//  Created by Leonardo Oliveira on 13/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import UserNotifications

class ChallengesTableViewController: UITableViewController, UNUserNotificationCenterDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var badgeSwitch: UISwitch!
    
    var titleStr: String?
    var textStr: String?
    var time: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        
        titleStr = titleTextField.text!
        
        textStr = textTextField.text!
        
        time = 0.0
        
        if timeTextField!.text != "0"{
            time = Double(self.timeTextField!.text!) as! Double
        }
        
        if titleStr != "" && textStr != "" && timeTextField.text != "" {
            
            notification(title: titleStr!, text: textStr!, time: time!, sound: soundSwitch.isOn, badge: badgeSwitch.isOn)
            
        } else{
            
            let alert = UIAlertController(title: "Incomplete or invalid data", message: nil, preferredStyle: UIAlertController.Style.alert)
            
            let fillLabelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(fillLabelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func notification(title: String, text: String, time: Double, sound: Bool, badge: Bool){
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                
                let content = UNMutableNotificationContent()
                content.categoryIdentifier = "notifications"
                content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: text, arguments: nil)
                
                if sound{
                    content.sound = UNNotificationSound.default
                }
                
                if badge{
                    content.badge = 1
                }
                
                let repeatAction = UNNotificationAction(identifier: "repeat", title: "Repeat", options: [])
                let openAction = UNNotificationAction(identifier: "open", title: "Open", options: [.foreground])
                
                let category = UNNotificationCategory(identifier: "notifications", actions: [repeatAction, openAction], intentIdentifiers: [], options: [])
                
                notificationCenter.setNotificationCategories([category])
                
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
                
                let request = UNNotificationRequest(identifier: "time", content: content, trigger: trigger)
                
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            
        if response.actionIdentifier == "repeat"{
            
            center.add(response.notification.request, withCompletionHandler: nil)
            
        } else if response.actionIdentifier == "open"{
            
            // present(SilverViewController(), animated: false, completion: nil)
            self.performSegue(withIdentifier: "segue", sender: self)
            
        }
    }
    
}
