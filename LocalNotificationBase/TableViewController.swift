//
//  TableViewController.swift
//  LocalNotificationBase
//
//  Created by Mariana Lima on 13/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import UserNotifications

class TableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return conteudopicker.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return conteudopicker [row]
    }

    
    @IBOutlet weak var titulobase: UITextField!
    @IBOutlet weak var corpobase: UITextField!
    @IBOutlet weak var segmentedControl: UISwitch!
    @IBOutlet weak var segmentedControlNot: UISwitch!
    @IBAction func enviar(_ sender: Any) {
        
        let content = UNMutableNotificationContent()
        if segmentedControl.isOn {
           
            content.sound = UNNotificationSound.default
        }
        else {
           
            content.sound = nil
        }
        if segmentedControlNot.isOn{
            content.badge = true
        }
        else {
            content.badge = false
        }
        
        if let texto = self.titulobase.text {
            content.title = NSString.localizedUserNotificationString(forKey: texto, arguments: nil)
        }
        
        if let corpo = self.corpobase.text {
            content.body = NSString.localizedUserNotificationString(forKey: corpo, arguments: nil)
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(self.picker.selectedRow(inComponent: 0)), repeats: false)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                
               
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

    @IBOutlet weak var picker: UIPickerView!
    var conteudopicker : [String] = [String] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conteudopicker = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
        picker.delegate = self
        picker.dataSource = self
    }
}
