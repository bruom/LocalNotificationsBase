//
//  BronzeTableViewController.swift
//  LocalNotificationBase
//
//  Created by Victor Falcetta do Nascimento on 13/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import UserNotifications

class BronzeTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var fieldTitulo: UITextField!
    @IBOutlet weak var fieldCorpo: UITextField!
    @IBOutlet weak var pickerTempoSeg: UIPickerView!
    @IBOutlet weak var switchSom: UISwitch!
    @IBOutlet weak var switchBadge: UISwitch!
    
    var pickerDadosSeg: [String] = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerTempoSeg.delegate = self
        self.pickerTempoSeg.dataSource = self
        
        pickerDadosSeg = ["0","1","2","3","4","5","6","7","8","9"]
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDadosSeg.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDadosSeg[row]
    }
    
    
    
    @IBAction func botaoEnviar(_ sender: Any) {
        let contentudo = UNMutableNotificationContent()
        
        if let tituloFieldText = self.fieldTitulo.text{
            contentudo.title = NSString.localizedUserNotificationString(forKey: tituloFieldText, arguments: nil)
        }
        
        if let corpoFieldText = self.fieldCorpo.text{
            contentudo.title = NSString.localizedUserNotificationString(forKey: corpoFieldText, arguments: nil)
        }
        
        
        
        if self.switchSom.isOn {
            contentudo.sound = UNNotificationSound.default
        }
        
        let triggerino = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(pickerTempoSeg.selectedRow(inComponent: 0)) , repeats: false)
        
        let request = UNNotificationRequest(identifier: "BronzeOmella", content: contentudo, trigger: triggerino)
        
        if self.switchBadge.isOn{
            contentudo.badge = 1
        }
        
        let bronzeNotificationCenter = UNUserNotificationCenter.current()
        bronzeNotificationCenter.getNotificationSettings{ (settings) in
            if settings.authorizationStatus == .authorized{
                let center = UNUserNotificationCenter.current()
                center.add(request) { (error : Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }else{
                print("Impossível mandar notificação - permissão negada")
            }
        }
    }
}
    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

