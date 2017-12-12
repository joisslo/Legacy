//
//  ProfileViewController.swift
//  CollegeIOS
//
//  Created by Joseph Rudeseal on 11/15/17.
//  Copyright © 2017 Jerry Hill. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    var campus: DTO_Campus? = nil
    var user: DTO_User? = nil
    var userPhoto: UIImage? = nil
    var userName: String? = nil
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ivUserPhoto: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfBirthDate: UITextField!
    @IBOutlet weak var tfGender: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfZipCode: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tvHobbies: UITextView!
    @IBOutlet weak var tfPolitic: UITextField!
    @IBOutlet weak var tfReligion: UITextField!
    @IBOutlet weak var tfBio: UITextField!
    @IBOutlet weak var btnFollow: UIButton!
    
    
    
    override func viewDidLoad() {
        //        super.viewDidLoad()
        //        if (userName == nil) {
        //            lblName.text = campus?.CampusName
        //        } else {
        //            if let text: String = userName {
        //                lblName.text = text
        //            }
        //        }
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 500)
        
        ivUserPhoto.image = userPhoto
        user = Store.storeInstance().user
        displayUser()
    }
    
    func displayUser() {
        lblName.text = "\(user?.first_name ?? "first_name") \(user?.last_name ?? "last_name")"
        tfBirthDate.text = user?.date_of_birth
        tfFirstName.text = user?.first_name
        tfLastName.text = user?.last_name
        tfGender.text = getGender()
        tfCity.text = user?.city
        tfState.text = user?.state
        tfZipCode.text = user?.zip
        tfReligion.text = user?.religion
        tfPolitic.text = user?.politic
        tfBio.text = user?.bio
        tfPhone.text = user?.phone
        tfEmail.text = user?.email_address
        tfAddress.text = user?.address
        
        var formattedHobbies = "Hobbies: "
        for index in 0...(user?.hobbies)!.count - 1 {
            if (index == (user?.hobbies)!.count - 1) {
                formattedHobbies.append("\((user?.hobbies[index])!)")
            } else {
                formattedHobbies.append("\((user?.hobbies[index])!), ")
            }
        }
        
        tvHobbies.text = formattedHobbies
        //See whether the user is already following this user and set the button accordingly
        btnFollow.isHidden = true
    }
    
    func getGender() -> String {
        let gender = Int((user?.genderType)!)
        switch gender {
        case 0?:
            return "Male"
        case 1?:
            return "Female"
        default:
            return "Other"
        }
    }
}
