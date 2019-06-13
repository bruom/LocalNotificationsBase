//
//  ViewController.swift
//  LocalNotificationBase
//
//  Created by Bruno Omella Mainieri on 12/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import UserNotifications

struct Notification {
    
    struct Category {
        static let tutorial = "tutorial"
    }
    
    struct Action {
        static let repetir = "repetir"
        static let next = "next"
    }
    
}

class BaseViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var badgeSwitch: UISwitch!
    @IBOutlet weak var soundsSwitch: UISwitch!
    
    var notification: NotificationModel?
    let mockTime = ["1","2","3","4","5","6","7","8"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        configureUserNotificationsCenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configureUserNotificationsCenter() {
        // Configure User Notification Center
        UNUserNotificationCenter.current().delegate = self
        // Define Actions
        let actionReadLater = UNNotificationAction(identifier: Notification.Action.repetir, title: "Repetir", options: [])
        let actionShowDetails = UNNotificationAction(identifier: Notification.Action.next, title: "Tela seguinte", options: [.foreground])
        
        // Define Category
        let tutorialCategory = UNNotificationCategory(identifier: Notification.Category.tutorial, actions: [actionReadLater, actionShowDetails], intentIdentifiers: [], options: [])
        
        // Register Category
        UNUserNotificationCenter.current().setNotificationCategories([tutorialCategory])
    }

    @IBAction func remindButton(_ sender: Any) {
        createNotification()
    }
    
    func createNotification() {
        notification = NotificationModel(title: self.titleTextField.text, message: self.messageTextField.text, time: Double(self.mockTime[pickerView.selectedRow(inComponent: 0)]) as! Double, badge: badgeSwitch.isOn, sound: soundsSwitch.isOn)
        let badgeNumber = UIApplication.shared.applicationIconBadgeNumber
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: self.notification!.title!, arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: self.notification!.message!, arguments: nil)
                content.sound = UNNotificationSound.default
                
                if self.notification!.badge {
                    content.badge = badgeNumber + 1 as NSNumber
                } else {
                    content.badge = nil
                }
                
                if self.notification!.sound {
                    content.sound = .default
                } else {
                    content.sound = nil
                }
                
                content.categoryIdentifier = Notification.Category.tutorial
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.notification!.time, repeats: false)
                
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case Notification.Action.repetir:
            createNotification()
        case Notification.Action.next:
            performSegue(withIdentifier: "segueToPoop", sender: nil)
        default:
            print("Other Action")
        }
        
        completionHandler()
    }
    
}

extension BaseViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.mockTime.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.mockTime[row]
    }
    
    
}
