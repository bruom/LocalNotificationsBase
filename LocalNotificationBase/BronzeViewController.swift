//
//  BronzeViewController.swift
//  LocalNotificationBase
//
//  Created by João Henrique Andrade on 13/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import UserNotifications

class BronzeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UNUserNotificationCenterDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return segundos.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(segundos[row])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerSegundos.delegate = self
        pickerSegundos.dataSource = self
        UNUserNotificationCenter.current().delegate = self
    }
    
    let segundos:[Int] = [1,2,3,4,5,6,7,8,9]
    @IBOutlet weak var switchSom: UISwitch!
    @IBOutlet weak var switchBadge: UISwitch!
    @IBOutlet weak var pickerSegundos: UIPickerView!
    @IBOutlet weak var corpoTexto: UITextField!
    @IBOutlet weak var tituloTexto: UITextField!
    
    @IBAction func enviar(_ nder: Any) {
        enviarNotificacao()
    }
    
    func enviarNotificacao(){
        let tituloNotificacao = self.tituloTexto.text
        let corpoNotificao = self.corpoTexto.text
        let soundOnOff: Bool = switchSom.isOn
        let badgeOnOff: Bool = switchBadge.isOn
        let valorSegundos : Double = Double(self.segundos[self.pickerSegundos.selectedRow(inComponent: 0)])
        var numeroBadges: Int = 0
        
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: tituloNotificacao!, arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: corpoNotificao!, arguments: nil)
                let userActions = "User Actions"
                content.categoryIdentifier = userActions
                
                if soundOnOff {
                    content.sound = UNNotificationSound.default
                }else {
                    content.sound = nil
                }
                
                if badgeOnOff{
                    numeroBadges += 1
                    content.badge = NSNumber(value: numeroBadges)
                }else {
                    content.badge = nil
                }
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: valorSegundos, repeats: false)
                let request = UNNotificationRequest(identifier: "5seconds", content: content, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(request) { (error : Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    
                    let repetirAcao = UNNotificationAction(identifier: "Repetir", title: "Repetir", options: [])
                    let abrirAplicativo = UNNotificationAction(identifier: "Abrir", title: "Abrir", options: [.foreground])
                    let category = UNNotificationCategory(identifier: userActions, actions: [repetirAcao, abrirAplicativo], intentIdentifiers: [], options: [])
                    notificationCenter.setNotificationCategories([category])
                    
                }
            } else {
                print("Impossível mandar notificação - permissão negada")
            }
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier{
        case "Abrir":
//            performSegue(withIdentifier: "", sender: nil)
            tabBarController?.selectedIndex = 0
        case "Repetir":
            enviarNotificacao()
            
        default:
            print("Ocorreu um erro na hora de abrir a notificação")
        }
        completionHandler()
    }
}
