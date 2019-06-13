//
//  ChallengesTableVC.swift
//  LocalNotificationBase
//
//  Created by Lucas Fernandez Nicolau on 13/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import UserNotifications

enum Action: String {
    case repeats = "repeats"
    case performSegue = "performSegue"
}

class ChallengesTableVC: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UNUserNotificationCenterDelegate {

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var bodyTextField: UITextField!
    @IBOutlet var soundSwitch: UISwitch!
    @IBOutlet var badgesSwitch: UISwitch!
    @IBOutlet var timePickerView: UIPickerView!
    
    var timeIntervals = [Int]()
    var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.delaysContentTouches = false
        tableView.keyboardDismissMode = .interactive
        
        timePickerView.dataSource = self
        timePickerView.delegate = self
        
        titleTextField.delegate = self
        titleTextField.autocapitalizationType = .words
        titleTextField.clearButtonMode = .whileEditing
        titleTextField.returnKeyType = .done
        
        bodyTextField.delegate = self
        bodyTextField.autocapitalizationType = .sentences
        bodyTextField.clearButtonMode = .whileEditing
        bodyTextField.returnKeyType = .done
        
        for i in 3 ... 20 {
            timeIntervals.append(i)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeIntervals.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(timeIntervals[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRow = row
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        guard let title = titleTextField.text,
            titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" else { return }
        guard let body = bodyTextField.text,
            bodyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" else { return }
        
        let timeInterval = TimeInterval(timeIntervals[selectedRow])
        setNotification(with: title, and: body, in: timeInterval, using: [soundSwitch.isOn, badgesSwitch.isOn])
    }
    
    func setNotification(with title: String, and body: String, in seconds: TimeInterval, using options: [Bool]) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        
        let repeatAction = UNNotificationAction(identifier: Action.repeats.rawValue,
                                                title: "Repeat",
                                                options: [])
        
        let performSegueAction = UNNotificationAction(identifier: Action.performSegue.rawValue,
                                                      title: "Perform Segue", options: [.foreground])
        
        let generalCategory = UNNotificationCategory(identifier: "generalCatID",
                                                     actions: [repeatAction, performSegueAction],
                                                     intentIdentifiers: [],
                                                     options: [.customDismissAction])
        
        notificationCenter.setNotificationCategories([generalCategory])
        
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: body, arguments: nil)
                content.sound = options[0] ? UNNotificationSound.default : nil
                content.badge = options[1] ? 1 : 0
                content.categoryIdentifier = "generalCatID"
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
                let request = UNNotificationRequest(identifier: "testNotification", content: content, trigger: trigger)
                
                notificationCenter.add(request) { (error : Error?) in
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
        
        switch response.actionIdentifier {
            case Action.repeats.rawValue:
                center.add(response.notification.request, withCompletionHandler: nil)
            case Action.performSegue.rawValue:
                performSegue(withIdentifier: "secondScreenSegue", sender: self)
            default:
                return
        }
        
        completionHandler()
    }
}
