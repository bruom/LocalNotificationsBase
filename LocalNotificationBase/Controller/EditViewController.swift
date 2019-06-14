//
//  editViewController.swift
//  LocalNotificationBase
//
//  Created by Matheus Gois on 13/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var titleNotification: UITextField!
    @IBOutlet weak var bodyNotification: UITextField!
    
    @IBOutlet weak var changeTimePickerNotification: UIPickerView!
    @IBOutlet weak var enableSoundNotification: UISwitch!
    @IBOutlet weak var enableBadgeNotification: UISwitch!
    
    var array = ["1","2","3","4","5","6","7","8","9","10"]
    var timeSelected = ""
    
    @IBAction func sendNotification(_ sender: UIButton) {
        let title  = titleNotification.text as! String
        let body  = bodyNotification.text as! String
        let stateBadge = self.enableBadgeNotification.isOn
        let stateSound = self.enableSoundNotification.isOn
        guard let time = TimeInterval(self.timeSelected) else { return }
        
        sendNotificationLocal(title, body, "1", time, stateSound, (stateBadge ? 1 : 0))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeSelected = array[0]

        // Do any additional setup after loading the view.
        self.changeTimePickerNotification.delegate = self
        self.changeTimePickerNotification.dataSource = self
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return array.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return array[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timeSelected = array[row]
    }

    

}


//func stringFromTimeInterval (interval: String) -> TimeInterval {
//    let endingDate = Date()
//    if let timeInterval = TimeInterval(interval) {
//        let startingDate = endingDate.addingTimeInterval(-timeInterval)
//        let calendar = Calendar.current
//
//        var componentsNow = calendar.dateComponents([.hour, .minute, .second], from: startingDate, to: endingDate)
//        if let hour = componentsNow.hour, let minute = componentsNow.minute, let seconds = componentsNow.second {
//            return "\(hour):\(minute):\(seconds)"
//        } else {
//            return "00:00:00"
//        }
//
//    } else {
//        return "00:00:00"
//    }
//}
