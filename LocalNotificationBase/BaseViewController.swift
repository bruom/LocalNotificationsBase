//
//  ViewController.swift
//  LocalNotificationBase
//
//  Created by Bruno Omella Mainieri on 12/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import UserNotifications

class BaseViewController: UITableViewController, UITextFieldDelegate, UNUserNotificationCenterDelegate{

    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    @IBOutlet weak var triggerTextField: UITextField!
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var badgeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self.view,
                                         action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
    }
    
    @IBAction func copperButton(_ sender: Any) {
        
        var title : String = self.titleTextField.text ?? "Recuerda-me"
        title = title.isEmpty ? "Recuerda-me" : title
        var body : String = self.bodyTextField.text ?? "Aunque Tenga Que Emigrar"
        body = body.isEmpty ? "Aunque Tenga Que Emigrar" : body
        let triggerTime : Double = (self.triggerTextField.text != nil) ? Double(self.triggerTextField.text!) ?? 5 : 5

        
        let sound : Bool = self.soundSwitch.isOn
        let badge : Bool = self.badgeSwitch.isOn
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: title,
                                                                         arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: body,
                                                                        arguments: nil)
                
                if sound{
                    content.sound = UNNotificationSound.default
                }
                
                if badge{
                    content.badge = 1
                }
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerTime,
                                                                repeats: false)
                
                let request = UNNotificationRequest(identifier: "copper",
                                                    content: content,
                                                    trigger: trigger)
                
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
    
    @IBAction func silverButton(_ sender: Any) {
        silverNotification()
    }
    @IBAction func goldButton(_ sender: Any) {
        silverNotification()
    }
    
    func silverNotification(){
        var title : String = self.titleTextField.text ?? "Recuerda-me"
        title = title.isEmpty ? "Recuerda-me" : title
        var body : String = self.bodyTextField.text ?? "Aunque Tenga Que Emigrar"
        body = body.isEmpty ? "Aunque Tenga Que Emigrar" : body
        let triggerTime : Double = (self.triggerTextField.text != nil) ? Double(self.triggerTextField.text!) ?? 5 : 5
        
        
        let sound : Bool = self.soundSwitch.isOn
        let badge : Bool = self.badgeSwitch.isOn
        
        let repeatAction = UNNotificationAction(identifier: "repeatAction",
                                                title: "Repeat",
                                                options: [.foreground])
        let openAction = UNNotificationAction(identifier: "openAction",
                                              title: "Let's Go",
                                              options: [.foreground])
        
        let silverCategory = UNNotificationCategory(identifier: "silverCategory",
                                                    actions: [repeatAction, openAction],
                                                    intentIdentifiers: [],
                                                    options: [])
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        notificationCenter.setNotificationCategories([silverCategory])
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: title,
                                                                         arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: body,
                                                                        arguments: nil)
                content.categoryIdentifier = "silverCategory"
                
                if sound{
                    content.sound = UNNotificationSound.default
                }
                
                if badge{
                    content.badge = 1
                }
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerTime,
                                                                repeats: false)
                
                let request = UNNotificationRequest(identifier: "copper",
                                                    content: content,
                                                    trigger: trigger)
                
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "repeatAction":
            silverNotification()
            break
        case "openAction":
            performSegue(withIdentifier: "silverSegue", sender: self)
        default:
            print("Notifications Actions Not Working Properly")
        }
    }
    
    
}
