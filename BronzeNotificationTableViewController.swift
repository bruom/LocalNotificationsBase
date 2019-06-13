//
//  BronzeNotificationTableViewController.swift
//  LocalNotificationBase
//
//  Created by Julia Santos on 13/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import UserNotifications

class BronzeNotificationTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerTimeData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerTimeData[row]
    }
    
    @IBOutlet weak var titulo: UITextField!
    
    @IBOutlet weak var corpo: UITextField!
    
    @IBOutlet weak var labelTempo: UILabel!
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var labelSom: UILabel!
    
    @IBOutlet weak var labelBadge: UILabel!
    
    @IBOutlet weak var segmentedControlBadge: UISwitch!
    
    
    @IBOutlet weak var segmentedControl: UISwitch!
    

    
    @IBAction func button(_ sender: Any) {
        
        let content = UNMutableNotificationContent()
        if segmentedControlBadge.isOn {
            content.badge = true
        }else{
            content.badge = false
        }
        if segmentedControl.isOn {
//            let content = UNMutableNotificationContent()
            content.sound = UNNotificationSound.default
        }
        else{
//           let content = UNMutableNotificationContent()
            content.sound = nil
        }
        
        
        if let texto = self.titulo.text {
            content.title = NSString.localizedUserNotificationString(forKey: texto, arguments: nil)
        }
        
        if let bodyy = self.corpo.text{
            content.body = NSString.localizedUserNotificationString(forKey: bodyy, arguments: nil)
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
    
    var pickerTimeData: [String] = [String]()
    
    var celulaEstaGrande:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerTimeData = ["1", "2", "3", "4", "5", "6", "7", "8"]
        self.picker.delegate = self
        self.picker.dataSource = self
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 0 {
            if celulaEstaGrande {
                return 250
            }
            else {
                return 44
            }
        }
        return 44
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0{
            celulaEstaGrande = !celulaEstaGrande
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}
