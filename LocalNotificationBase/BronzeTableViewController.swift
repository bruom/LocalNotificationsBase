//
//  BronzeTableViewController.swift
//  LocalNotificationBase
//
//  Created by Lia Kassardjian on 13/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import UserNotifications

class BronzeTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var tituloTextField: UITextField!
    @IBOutlet weak var descricaoTextField: UITextField!
    @IBOutlet weak var pickerTableViewCell: UITableViewCell!
    @IBOutlet weak var tempoPickerView: UIPickerView!
    @IBOutlet weak var somSwitch: UISwitch!
    @IBOutlet weak var badgeSwitch: UISwitch!
    
    var valoresPicker:[Double] = []
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        super.viewDidLoad()
        
        self.tempoPickerView.delegate = self
        self.tempoPickerView.dataSource = self
        gerarNumeros()
    }

    @IBAction func agendarButton(_ sender: Any) {
        
        let titulo:String = leTextField(textField: self.tituloTextField)
        let descricao:String = leTextField(textField: self.descricaoTextField)
        var tempo:Double = 0
        var som = true
        var badge = true
        
        if let tempoPV = self.tempoPickerView {
            tempo = self.valoresPicker[tempoPV.selectedRow(inComponent: 0)]
        }
        
        if let somS = self.somSwitch {
            if !somS.isOn {
                som = false
            }
        }
        
        if let badgeS = self.badgeSwitch {
            if !badgeS.isOn {
                badge = false
            }
        }
        
        enviaNotificacao(titulo: titulo, descricao: descricao, tempo: tempo, som: som, badge: badge)
    }
    
    func enviaNotificacao(titulo: String, descricao: String, tempo: Double, som: Bool, badge: Bool) {
        let content = UNMutableNotificationContent()
        content.title = titulo
        content.body = descricao
        
        if som {
            content.sound = UNNotificationSound.default
        } else {
            content.sound = .none
        }
        
        if badge {
            content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: tempo, repeats: false)
        
        let request = UNNotificationRequest(identifier: "bronze", content: content, trigger: trigger)
        
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                
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
    
    func leTextField(textField: UITextField?) -> String {
        if let tf = textField {
            if let texto = tf.text{
                return texto
            }
        }
        return ""
    }
    
    func gerarNumeros() {
        if valoresPicker.isEmpty {
            for i in 1...60 {
                valoresPicker.append(Double(i))
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return valoresPicker.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(format: "%.0f", valoresPicker[row])
    }

}
