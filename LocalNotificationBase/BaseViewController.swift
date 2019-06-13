//
//  ViewController.swift
//  LocalNotificationBase
//
//  Created by Bruno Omella Mainieri on 12/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import UserNotifications

class BaseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UNUserNotificationCenterDelegate {
    
    
    let time = [1,2,3,4,5,6,7,8,9]
    
    
    
    
    
    @IBOutlet weak var titleNotification: UITextField!
    @IBOutlet weak var bodyNotification: UITextField!
    @IBOutlet weak var soundBool: UISwitch!
    @IBOutlet weak var badgeBool: UISwitch!
    
    var titulo = ""
    var corpo = ""
    var som = false
    var badge = false
    var intervaloDeTempo = 0
    
    var timer_for_notification = 0
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let Show =  time[row] as NSNumber
        return Show.stringValue
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return time.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timer_for_notification = time[row]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    func createNotifcation(){
        let repeatAction = UNNotificationAction(identifier: "repetir", title: "Repetir")
        let okAction = UNNotificationAction(identifier: "ok", title: "ok", options: UNNotificationActionOptions.foreground)
        
        
        let category = UNNotificationCategory(identifier: "Options", actions: [okAction,repeatAction], intentIdentifiers: [],  options: [])
        
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([category])
        
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: self.titulo, arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: self.corpo, arguments: nil)
                if self.som{
                    content.sound = UNNotificationSound.default
                }
                content.categoryIdentifier = "Options"
                if self.badge{
                    content.badge = UIApplication.shared.applicationIconBadgeNumber  +  1 as NSNumber
                    
                }
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(self.intervaloDeTempo), repeats: false)
                
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
    @IBAction func remindButton(_ sender: Any) {
        titulo = self.titleNotification.text!
        corpo = self.bodyNotification.text!
        som = self.soundBool.isOn
        badge = self.badgeBool.isOn
        intervaloDeTempo = timer_for_notification
        createNotifcation()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "repetir"{
            createNotifcation()
                }else{
            
        }
    }
    
}

