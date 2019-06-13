//
//  BronzeContorller.swift
//  LocalNotificationBase
//
//  Created by Juliana Vigato Pavan on 13/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class BronzeController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    //number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    

    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerData = ["1","2","3","4","5","6","7","8","9","10"]
        
        self.pickerViewTime.delegate = self
        self.pickerViewTime.dataSource = self
    }
    
    @IBOutlet weak var TitleLabel: UITextField!
    @IBOutlet weak var BodyLabel: UITextField!
    @IBOutlet weak var pickerViewTime: UIPickerView!
    
    @IBOutlet weak var SoundSwitch: UISwitch!
    
    @IBOutlet weak var BadgeSwitch: UISwitch!
    
    
    @IBAction func SubmitButton(_ sender: Any) {
        let notificationCnter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        if let titleText = self.TitleLabel.text{
            content.title = NSString.localizedUserNotificationString(forKey: titleText, arguments: nil)
        }
        if let bodyText = self.BodyLabel.text{
            content.body = NSString.localizedUserNotificationString(forKey: bodyText, arguments: nil)
        }
        
        if SoundSwitch.isOn{
            content.sound = UNNotificationSound.default
        }
        
        if BadgeSwitch.isOn{
            content.badge = 1
        }
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval((pickerViewTime.selectedRow(inComponent: 0))+1), repeats: false)
        
        let request = UNNotificationRequest(identifier: "Time notification", content: content, trigger: trigger)
        
        notificationCnter.getNotificationSettings{ (settings) in
            if settings.authorizationStatus == .authorized{
                let center = UNUserNotificationCenter.current()
                center.add(request) { (error : Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            } else{
                print("Impossivel mandar notificacao!")
            }
        }
    }
}


