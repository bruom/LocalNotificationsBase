//
//  BronzeTableViewController.swift
//  LocalNotificationBase
//
//  Created by Zewu Chen on 13/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import UserNotifications

class BronzeTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        //Request
        let request = UNNotificationRequest(identifier: "timeChoice", content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
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
    
}
