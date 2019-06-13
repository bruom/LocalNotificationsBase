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
    
    
    @IBOutlet weak var Sound: UISwitch!
    @IBOutlet weak var Badge: UISwitch!
    @IBOutlet weak var NotificationTitle: UITextField!
    @IBOutlet weak var NotificationInfo: UITextField!
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    } // numero de colunas
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count // numero de elementos dentro do vetor
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row] // se refere a um elemento especifico do vetor
    }
    

    @IBOutlet weak var picker: UIPickerView!
    
    var pickerData: [String] = [String]() // cria o vetor
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.picker.delegate = self
        self.picker.dataSource = self
        pickerData = ["1","2","3","4","5","6","7","8","9"] // numero de elementos
        configureUserNotificationsCenter()
        
    }
    
    private func configureUserNotificationsCenter() {
        // Configure User Notification Center
        UNUserNotificationCenter.current().delegate = self
        let actionShowDetails = UNNotificationAction(identifier: Notification.Action.showDetails, title: "Show Details", options: [.foreground])
        let actionRepete = UNNotificationAction(identifier: Notification.Action.repete, title: "Repeat", options: [])
        let tutorialCategory = UNNotificationCategory(identifier: Notification.Category.tutorial, actions: [actionRepete, actionShowDetails], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([tutorialCategory])
    }

    struct Notification {
        struct Category {
            static let tutorial = "tutorial"
        }
        struct Action {
            static let repete = "repete"
            static let showDetails = "showDetails"
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case Notification.Action.repete:
            CreateNotification()
            
        case Notification.Action.showDetails:
            performSegue(withIdentifier: "segue", sender: nil)
            
            
        default:
            print("Other Action")
        }
        
        completionHandler()
    }
    
    func CreateNotification () {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                
                let content = UNMutableNotificationContent()
                if self.NotificationTitle.text != nil {
                    content.title = NSString.localizedUserNotificationString(forKey: self.NotificationTitle.text!, arguments: nil)
                } else {
                    self.NotificationTitle.text = ""
                    content.title = NSString.localizedUserNotificationString(forKey: self.NotificationTitle.text!, arguments: nil)
                }
                
                if self.NotificationInfo.text != nil {
                    content.body = NSString.localizedUserNotificationString(forKey: self.NotificationInfo.text!, arguments: nil)
                } else {
                    self.NotificationInfo.text = ""
                    content.body = NSString.localizedUserNotificationString(forKey: self.NotificationInfo.text!, arguments: nil)
                }
                
                if self.Sound.isOn {
                    content.sound = UNNotificationSound.default
                } else {
                    print("n vai ter som")
                }
                
                if self.Badge.isOn {
                    content.badge = 1
                } else {
                    print("Nada ocorre")
                }
                
                content.categoryIdentifier = Notification.Category.tutorial      // usa da categoria Tutorial
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(self.pickerData[self.picker.selectedRow(inComponent: 0)]) as! TimeInterval, repeats: false)
                
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
        CreateNotification()
    }
}

    
    

    


