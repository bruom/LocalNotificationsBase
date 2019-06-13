//
//  BronzeVC.swift
//  LocalNotificationBase
//
//  Created by Cassia Aparecida Barbosa on 13/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import UserNotifications

class Bronze: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
}
    
    @IBOutlet weak var titulo: UITextField!
    
    @IBOutlet weak var corpo: UITextField!
    
    @IBOutlet weak var tempo: UITextField!

    
    @IBOutlet weak var somSwitch: UISwitch!
    
    
    @IBOutlet weak var notificacaoSwitch: UISwitch!
    
    
    
    @IBAction func criarNotificacao(_ sender: Any) {
        let notificationCenter = UNUserNotificationCenter.current()
        guard let tempoUsado = self.tempo?.text as? String else{return}
        guard let tituloUsado = self.titulo?.text as? String else{return}
        guard let corpoUsado = self.corpo?.text as? String else{return}
        notificationCenter.getNotificationSettings { (settings) in
            
            
            if settings.authorizationStatus == .authorized {
                if self.somSwitch.isOn {
                    
                    let content = UNMutableNotificationContent()
                    content.title = NSString.localizedUserNotificationString(forKey: tituloUsado, arguments: nil)
                    content.body = NSString.localizedUserNotificationString(forKey: corpoUsado, arguments: nil)
                    content.sound = nil
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(tempoUsado) as! TimeInterval, repeats: false)
                    
                    let request = UNNotificationRequest(identifier: "tempoSetado", content: content, trigger: trigger)
                    
                    let center = UNUserNotificationCenter.current()
                    center.add(request) { (error : Error?) in
                        if let error = error {
                            print(error.localizedDescription)                    }                }
                    
                } else {
                    print("Impossível mandar notificação - permissão negada")
                }
            }    }
        
    }

}
