//
//  PickerDelegates.swift
//  CollegeIOS
//
//  Created by Joseph Rudeseal on 11/24/17.
//  Copyright © 2017 Jerry Hill. All rights reserved.
//

import Foundation
import UIKit

class SuperPickerDelegate: NSObject {
    var chosenValue = ""
}

class StatePickerDelegate: SuperPickerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    let states = Store.storeInstance().states
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        super.chosenValue = states[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row].name
    }
}

class ReligionPickerDelegate: SuperPickerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    let test = ["None", "Christian", "Jewish", "Muslim"]
    let religions = Store.storeInstance().religions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        super.chosenValue = religions[row].religion
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return religions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return religions[row].religion
    }
}

class PoliticsPickerDelegate: SuperPickerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    let politics = Store.storeInstance().politics
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        super.chosenValue = politics[row].politic
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return politics.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return politics[row].politic
    }
}

