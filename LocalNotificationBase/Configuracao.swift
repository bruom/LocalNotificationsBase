//
//  Configuracao.swift
//  LocalNotificationBase
//
//  Created by Fabrício Guilhermo on 13/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit

class Configuracao: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var titleNotification: UITextField!
    @IBOutlet weak var bodyNotification: UITextField!
    @IBOutlet weak var pickerTimeWating: UIPickerView!
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var badgeSwitch: UISwitch!
    
    var elem = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    var pickerSelected = ""
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return elem.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return elem[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelected = elem[row]
    }
    
    @IBAction func doneButton(_ sender: Any) {
        let title = self.titleNotification.text as! String
        let body  = self.bodyNotification.text as! String
        let sound = self.soundSwitch.isOn
        let badge = self.badgeSwitch.isOn
        guard let time  = TimeInterval(pickerSelected) else { return }
        editarNotificacao(title, body, "", time, badge ? 1 : 0, sound)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerSelected = elem[0]
        self.pickerTimeWating.delegate   = self
        self.pickerTimeWating.dataSource = self
    }
}
