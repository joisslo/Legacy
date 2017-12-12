//
//  EditProfileViewController.swift
//  CollegeIOS
//
//  Created by Joseph Rudeseal on 11/24/17.
//  Copyright © 2017 Jerry Hill. All rights reserved.
//

import Foundation
import UIKit

class EditProfileViewController: UIViewController, UITextFieldDelegate {
    
    var dm = DataManager()
    
    var campus: DTO_Campus? = nil
    var userPhoto: UIImage? = nil
    var userName: String? = nil
    var activeTextField = UITextField()
    let cityPicker = UIPickerView()
    let statePicker = UIPickerView()
    let religionPicker = UIPickerView()
    let politicsPicker = UIPickerView()
    let statePickerDelegate = StatePickerDelegate()
    let religionPickerDelegate = ReligionPickerDelegate()
    let politicsPickerDelegate = PoliticsPickerDelegate()
    
    @IBOutlet weak var scGender: UISegmentedControl!
    @IBOutlet weak var tfBirthDate: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ivUserPhoto: UIImageView!
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var btnHobbies: UIButton!
    @IBOutlet weak var tfBio: UITextField!
    @IBOutlet weak var tfReligion: UITextField!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfZipCode: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPolitics: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (userName == nil) {
            lblName.text = campus?.CampusName
        } else {
            if let text: String = userName {
                lblName.text = text
            }
        }
        tfFirstName.delegate = self
        tfLastName.delegate = self
        tfAddress.delegate = self
        tfPhone.delegate = self
        tfEmail.delegate = self
        tfCity.delegate = self
        
        
        //Experimenting with option picker
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(EditProfileViewController.donePicker))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        statePicker.delegate = statePickerDelegate
        statePicker.dataSource = statePickerDelegate
        religionPicker.delegate = religionPickerDelegate
        religionPicker.dataSource = religionPickerDelegate
        politicsPicker.delegate = politicsPickerDelegate
        politicsPicker.dataSource = politicsPickerDelegate
        tfState.inputView = statePicker
        tfState.inputAccessoryView = toolBar
        tfState.delegate = self
        tfBio.delegate = self
        btnHobbies.layer.borderWidth = 1.0
        tfReligion.inputView = religionPicker
        tfReligion.inputAccessoryView = toolBar
        tfReligion.delegate = self
        tfPolitics.inputView = politicsPicker
        tfPolitics.inputAccessoryView = toolBar
        tfPolitics.delegate = self
        tfZipCode.inputAccessoryView = toolBar
        tfZipCode.delegate = self
        tfPhone.inputAccessoryView = toolBar
        tfBirthDate.inputAccessoryView = toolBar
        
        
        for s in Store.storeInstance().user.hobbies {
            print(s)
        }
        //ivUserPhoto.image = userPhoto
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 250)
        populateFieldsFromUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateHobbies()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateUser()
    }
    
    @objc func donePicker() {
        if activeTextField.inputView != nil && type(of: activeTextField.inputView!) == UIPickerView.self {
            let activePicker = activeTextField.inputView as? UIPickerView
            let activePickerDelegate = activePicker?.delegate as? SuperPickerDelegate
            activeTextField.text = activePickerDelegate?.chosenValue
            activeTextField.resignFirstResponder()
        } else {
            activeTextField.resignFirstResponder()
            self.view.endEditing(true)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
        print(activeTextField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func updateHobbies() {
        var hobbies = Store.storeInstance().user.hobbies
        var formattedHobbies = "Hobbies: "
        for index in 0...hobbies.count - 1 {
            if (index == hobbies.count - 1) {
                formattedHobbies.append("\(hobbies[index])")
            } else {
                formattedHobbies.append("\(hobbies[index]), ")
            }
        }
        btnHobbies.setTitle(formattedHobbies, for: .normal)
    }
    
    @IBAction func birthDateEditing(_ sender: UITextField) {
        let birthdatePickerView: UIDatePicker = UIDatePicker()
        birthdatePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = birthdatePickerView
        birthdatePickerView.addTarget(self, action: #selector(datePickerValueChangedEdit), for: UIControlEvents.valueChanged)
    }
    
    
    @objc func datePickerValueChangedEdit(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        tfBirthDate.text = dateFormatter.string(from: sender.date)
    }
    
    //Close Keyboard when touching outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func updateUser() {
        let tempUser = Store.storeInstance().user
        tempUser.date_of_birth = tfBirthDate.text!
        tempUser.first_name = tfFirstName.text!
        tempUser.last_name = tfLastName.text!
        tempUser.genderType = "\(scGender.selectedSegmentIndex)"
        tempUser.city = tfCity.text!
        tempUser.state = tfState.text!
        tempUser.zip = tfZipCode.text!
        tempUser.religion = tfReligion.text!
        tempUser.politic = tfPolitics.text!
        tempUser.bio = tfBio.text!
        tempUser.phone = tfPhone.text!
        tempUser.email_address = tfEmail.text!
        tempUser.address = tfAddress.text!
        Store.storeInstance().user = tempUser
    }
    
    func populateFieldsFromUser() {
        let user = Store.storeInstance().user
        tfBirthDate.text = user.date_of_birth
        tfFirstName.text = user.first_name
        tfLastName.text = user.last_name
        scGender.selectedSegmentIndex = setGender()
        tfCity.text = user.city
        tfState.text = user.state
        tfZipCode.text = user.zip
        tfReligion.text = user.religion
        tfPolitics.text = user.politic
        tfBio.text = user.bio
        tfPhone.text = user.phone
        tfEmail.text = user.email_address
        tfAddress.text = user.address
        lblName.text = "\(user.first_name) \(user.last_name)"
    }
    
    func setGender() -> Int {
        switch (Store.storeInstance().user.genderType) {
        case "NOT ASSIGNED":
            return 2
        case "Female":
            return 1
        default:
            return 0
        }
    }
}


