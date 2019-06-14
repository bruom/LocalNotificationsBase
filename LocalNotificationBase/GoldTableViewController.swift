//
//  GoldTableViewController.swift
//  LocalNotificationBase
//
//  Created by Zewu Chen on 14/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import UserNotifications

class GoldTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UNUserNotificationCenterDelegate {


    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var switchSound: UISwitch!
    @IBOutlet weak var switchBadge: UISwitch!
    
    var pickerData: [String] = []
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        super.viewDidLoad()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        pickerData = ["2", "4", "6", "8", "10"]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    
    @IBAction func btnEnviar(_ sender: Any) {
        notification()
    }
    
    func notification(){
        let repeatAction = UNNotificationAction(identifier: "REPEAT_ACTION", title: "Repetir", options: UNNotificationActionOptions(rawValue: 0))
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION", title: "Ok", options: UNNotificationActionOptions(rawValue: 0))
        
        let meetingInviteCategory =
            UNNotificationCategory(identifier: "CUSTOM",
                                   actions: [repeatAction, acceptAction],
                                   intentIdentifiers: [],
                                   hiddenPreviewsBodyPlaceholder: "",
                                   options: .customDismissAction)
        
        //Cria a notificação fora
        let content = UNMutableNotificationContent()
        
        //Título
        if let title = self.txtTitle.text{
            content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
        }
        //Descrição
        if let description = self.txtDescription.text{
            content.body = NSString.localizedUserNotificationString(forKey: description, arguments: nil)
        }
        //Switch som
        if self.switchSound.isOn{
            content.sound = UNNotificationSound.default
        }else{
            content.sound = .none
        }
        //Switch badge
        if self.switchBadge.isOn{
            content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
        }
        //Trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(pickerData[pickerView.selectedRow(inComponent: 0)]) as! TimeInterval, repeats: false)
        
        content.categoryIdentifier = "CUSTOM"
        //Request
        let request = UNNotificationRequest(identifier: "timeChoiceCustom", content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        notificationCenter.setNotificationCategories([meetingInviteCategory])
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                
                //Adiciona a notificação
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
        // Get the meeting ID from the original notification.
        let userInfo = response.notification.request.content.userInfo
        
        // Perform the task associated with the action.
        switch response.actionIdentifier {
        case "ACCEPT_ACTION":
            print("Aceito")
            break
            
        case "REPEAT_ACTION":
            notification()
            break
            
        default:
            break
        }
        
        // Always call the completion handler when done.
        completionHandler()
    }
    
}
