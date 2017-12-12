//
//  TextFieldDelegates.swift
//  CollegeIOS
//
//  Created by Joseph Rudeseal on 11/29/17.
//  Copyright © 2017 Jerry Hill. All rights reserved.
//

import Foundation
import UIKit

class SuperTextFieldDelegate: NSObject {
    
}

class BioDelegate: SuperPickerDelegate, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
