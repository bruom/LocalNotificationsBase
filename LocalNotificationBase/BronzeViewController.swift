//
//  BronzeViewController.swift
//  LocalNotificationBase
//
//  Created by Luiz Henrique Monteiro de Carvalho on 13/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import UserNotifications
class BronzeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    

    
    
    @IBOutlet weak var tituloField: UITextField!
    @IBOutlet weak var corpoField: UITextField!
    
    
    @IBOutlet weak var pickerSegundos: UIPickerView!
    var pickerData: [String] = [String]()
    
    @IBOutlet weak var somSwitchOutlet: UISwitch!
    @IBOutlet weak var badgeSwitchOutlet: UISwitch!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerSegundos.delegate = self
        self.pickerSegundos.dataSource = self
        
        pickerData = ["0","1","2","3","4","5","6","7","8","9","10"]
        
        // Do any additional setup after loading the view.
    }
    

  

    @IBAction func enviarButton(_ sender: Any) {
        
        let notificationCenterBronze = UNUserNotificationCenter.current()
        let contentBronze = UNMutableNotificationContent()
        
        if let tituloFieldText = self.tituloField.text{
            contentBronze.title = NSString.localizedUserNotificationString(forKey: tituloFieldText, arguments: nil)
        }
        
        if let corpoFieldText = self.corpoField.text{
            contentBronze.body = NSString.localizedUserNotificationString(forKey: corpoFieldText, arguments: nil)
        }
        
        
        
        if self.somSwitchOutlet.isOn{
            contentBronze.sound = UNNotificationSound.default
        }else{
            contentBronze.sound = .none
        }
        
        if self.badgeSwitchOutlet.isOn{
            contentBronze.badge = 1
        }
        
        
        let triggerBronze = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(self.pickerSegundos.selectedRow(inComponent: 0)), repeats: false)
        
        
        let requestBronze = UNNotificationRequest(identifier: "XSegundos", content: contentBronze, trigger: triggerBronze)
        
        
        notificationCenterBronze.getNotificationSettings { (settingsBronze) in
            if settingsBronze.authorizationStatus == .authorized{
                
                let centerBronze = UNUserNotificationCenter.current()
                
                centerBronze.add(requestBronze) {(error: Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }else {
                print("Deu não")
            }
                
                
                
                
                
                
               
                
            }
        }
    }

//    let request = UNNotificationRequest(identifier: "5seconds", content: content, trigger: trigger)
//
//    let center = UNUserNotificationCenter.current()
//    center.add(request) { (error : Error?) in
//    if let error = error {
//    print(error.localizedDescription)
//    }
//    }
//
//} else {
//    print("Impossível mandar notificação - permissão negada")
//}
//

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


