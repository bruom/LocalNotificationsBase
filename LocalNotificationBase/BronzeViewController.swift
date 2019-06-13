//
//  TableViewController.swift
//  LocalNotificationBase
//
//  Created by Tamara Erlij on 13/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit

class BronzeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    

    @IBOutlet weak var titulo: UITextField!
    @IBOutlet weak var corpo: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var som: UISwitch!
    @IBOutlet weak var badge: UISwitch!
    
    let array = ["1","2","3","4","5","6","7","8","9","10"]
    var pickerSelected = ""
    
    @IBAction func enviar(_ sender: Any) {
        
        let titulo = self.titulo.text as! String
        let corpo = self.corpo.text as! String
        let som = self.som.isOn
        let badge = self.badge.isOn
    
        enviarNotificacao(titulo: titulo, corpo: corpo, identificador: "1", intervalo: pickerSelected, badge: badge, som: som)
//        print(titulo, corpo, som, badge, pickerSelected)
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        picker.dataSource = self
        picker.delegate = self
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
        pickerSelected = array[row]
    }
   

}
