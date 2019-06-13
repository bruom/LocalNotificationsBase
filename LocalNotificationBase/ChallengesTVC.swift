//
//  ChallengesTVC.swift
//  LocalNotificationBase
//
//  Created by Paula Leite on 13/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import UserNotifications

class ChallengesTVC: UITableViewController, UIPickerViewDelegate,  UIPickerViewDataSource, UNUserNotificationCenterDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var bodyTextField: UITextField!
    
    @IBOutlet weak var soundSwitch: UISwitch!
    
    @IBOutlet weak var badgeSwitch: UISwitch!
    
    @IBOutlet weak var timePicker: UIPickerView!
    
    var timeIntervals = [TimeInterval]()
    
    var selectedPickerIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false

        tableView.delaysContentTouches = false
        
        timeIntervals = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        
        self.timePicker.delegate = self
        self.timePicker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Adicionada para funcionar com Table View
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeIntervals.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(Int(timeIntervals[row]))"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPickerIndex = row
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func setNotificationButton(_ sender: Any) {
        
        guard let title = titleTextField.text else {
            return
        }
        
        guard let body = bodyTextField.text else {
            return
        }
        
        let soundIsOn = soundSwitch.isOn
        let badgeIsOn = badgeSwitch.isOn
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        let repeatNotification = UNNotificationAction(identifier: "repeat", title: "Repeat", options: [])
        
        let doDefinedAction = UNNotificationAction(identifier: "doAction", title: "All done!", options: [.foreground])
        
        // This is what iOS needs so he can make the actions
        let calledCategory = UNNotificationCategory(identifier: "calledCategory", actions: [repeatNotification, doDefinedAction], intentIdentifiers: [], options: .customDismissAction)
        
        notificationCenter.setNotificationCategories([calledCategory])
        notificationCenter.delegate = self
        
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: body, arguments: nil)
                if soundIsOn {
                    content.sound = UNNotificationSound.default
                }
                
                if badgeIsOn {
                    content.badge = 1
                }
                
                // This is how you make the category show up
                content.categoryIdentifier = "calledCategory"
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.timeIntervals[self.selectedPickerIndex], repeats: false)
                
                let request = UNNotificationRequest(identifier: "notificationTest", content: content, trigger: trigger)
                
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
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        if response.actionIdentifier == "repeat" {
            center.add(response.notification.request, withCompletionHandler: nil)
        } else if response.actionIdentifier == "doAction" {
            performSegue(withIdentifier: "textSegue", sender: self)
        }
    }
    

}
