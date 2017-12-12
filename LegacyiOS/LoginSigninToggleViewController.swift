//
//  LoginSigninToggleViewController.swift
//  CollegeIOS
//
//  Created by Joseph Rudeseal on 11/2/17.
//  Copyright © 2017 Jerry Hill. All rights reserved.
//

//Common Colors
//Dark Gray (Unselected Button): UIColor(red: 179.0/255.0, green: 179.0/255.0, blue: 179.0/255.0, alpha: 1.0)
//Light Gray (Selected Button) : UIColor.white

import Foundation
import UIKit
import Photos
import PhotosUI
import CoreLocation

//View controller for the Legacy Login/Signin screen
class LoginSigninToggleViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var ivEmail: UIImageView!
    @IBOutlet weak var ivPassword: UIImageView!
    @IBOutlet weak var linesSignIn: UIImageView!
    @IBOutlet var signInLines: [UIImageView]!
    @IBOutlet weak var btnSegue: UIButton!
    @IBOutlet weak var btnCreateAccountSegue: UIButton!
    @IBOutlet weak var uploadPhotoButton: UIButton!
    @IBOutlet var signUpImageViews: [UIImageView]!
    @IBOutlet weak var tfSignUpEmail: UITextField!
    @IBOutlet weak var tfSignUpConfirmEmail: UITextField!
    @IBOutlet weak var tfSignUpPassword: UITextField!
    @IBOutlet weak var tfSignUpConfirmPassword: UITextField!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var photoPicker: UIButton!
    @IBOutlet weak var ivUserPhoto: UIImageView!
    @IBOutlet weak var tfBirthDate: UITextField!
    @IBOutlet weak var genderPicker: UISegmentedControl!
    @IBOutlet weak var btnCamera: UIButton!
    
    
    var loc = CLLocationManager()
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var geocoder = CLGeocoder()
    let imagePicker = UIImagePickerController()
    var lat : CLLocationDegrees?
    var long : CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if (authorizationStatus == CLAuthorizationStatus.notDetermined) {
            locationManager?.requestWhenInUseAuthorization()
        } else {
            locationManager?.startUpdatingLocation()
        }
        
        
        tfEmail.delegate = self
        tfPassword.delegate = self
        tfSignUpEmail.delegate = self
        tfSignUpPassword.delegate = self
        tfSignUpConfirmPassword.delegate = self
        tfSignUpConfirmEmail.delegate = self
        tfFirstName.delegate = self
        tfLastName.delegate = self
        imagePicker.delegate = self
        ivUserPhoto.isHidden = true
        hideSignUpFields(arg: true, btnColor: UIColor(red: 179.0 / 255.0, green: 179.0 / 255.0, blue: 179.0 / 255.0, alpha: 1.0))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearFields()
    }
    
    @IBAction func continueButtonTouched(_ sender: UIButton) {
        let email = String(tfEmail.text!)
        let password = String(tfPassword.text!)
        tfPassword.text = ""
        print("Login Button was touched.\nEmail: \(email)\nPassword: \(password)")
        
        
        lat = locationManager?.location?.coordinate.latitude
        long = locationManager?.location?.coordinate.longitude
        print(lat!)
        print(long!)
        
        // Create Location
        let location = CLLocation(latitude: lat!, longitude: long!)
        
        // Geocode Location
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
        
        //Call the web service for a user
        let dm = DataManager()
        dm.attemptLogin(email: tfEmail.text!) { () in OperationQueue.main.addOperation {
            print("load finished")
            Store.storeInstance().user=Store.storeInstance().users[0]
            self.validateUser()
            }
        }
    }
    
    func validateUser() {
        //Present an alert controller, this is more or less practice, currently shows device lat/long
        var user = Store.storeInstance().user
        print(user.id)
        if (Store.storeInstance().user.id != 22) {
            //Successful Login
            print("Success")
            perfSeg()
        } else {
            //Unsuccessful Login
            let alertController = UIAlertController(title: title, message: "Latitude: \(lat ?? 0 ), Longitude: \(long ?? 0 )", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Invalid Login", style: .default))
            present(alertController, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        currentLocation = locations[locations.count - 1] as? CLLocation
        print("Locations =  \(currentLocation)")
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                print(placemark.compactAddress!)
            } else {
                print("No Matching Addresses Found")
            }
        }
    }
    
    
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        hideSignInFields(arg: false, btnColor: UIColor.white)
        hideSignUpFields(arg: true, btnColor: UIColor(red: 179.0 / 255.0, green: 179.0 / 255.0, blue: 179.0 / 255.0, alpha: 1.0))
        ivUserPhoto.image = nil
        ivUserPhoto.isHidden = true
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        hideSignInFields(arg: true, btnColor: UIColor(red: 179.0 / 255.0, green: 179.0 / 255.0, blue: 179.0 / 255.0, alpha: 1.0))
        hideSignUpFields(arg: false, btnColor: UIColor.white)
    }
    
    @IBAction func birthdateEditing(_ sender: UITextField) {
        let birthdatePickerView: UIDatePicker = UIDatePicker()
        birthdatePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = birthdatePickerView
        birthdatePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        tfBirthDate.text = dateFormatter.string(from: sender.date)
    }
    
    //This is called from the alertController. initiates a segue to the home screen
    //TODO: remove current implementation, the segue should be called programmatically when
    //a valid DTO_Login object is received
    func perfSeg() {
        btnSegue.sendActions(for: .touchUpInside)
    }
    
    func createAccountSegue() {
        btnCreateAccountSegue.sendActions(for: .touchUpInside)
    }
    
    //Advance to next field for for easy text entry and navigation
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    //Close Keyboard when touching outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    //Show or hide the fields that should be associated with the sign in screen
    func hideSignInFields(arg: Bool, btnColor: UIColor) {
        signInButton.backgroundColor = btnColor
        continueButton.isHidden = arg
        forgotPasswordButton.isHidden = arg
        for image in signInLines {
            image.isHidden = arg
        }
        tfEmail.isHidden = arg
        tfPassword.isHidden = arg
        tfEmail.resignFirstResponder()
        tfPassword.resignFirstResponder()
    }
    
    //Show or hide the fields that should be associated with the sign up screen
    func hideSignUpFields(arg: Bool, btnColor: UIColor) {
        signUpButton.backgroundColor = btnColor
        createAccountButton.isHidden = arg
        uploadPhotoButton.isHidden = arg
        for image in signUpImageViews {
            image.isHidden = arg
        }
        btnCamera.isHidden = arg
        tfSignUpEmail.isHidden = arg
        tfSignUpEmail.resignFirstResponder()
        tfSignUpConfirmEmail.isHidden = arg
        tfSignUpConfirmEmail.resignFirstResponder()
        tfSignUpPassword.isHidden = arg
        tfSignUpPassword.resignFirstResponder()
        tfSignUpConfirmPassword.isHidden = arg
        tfSignUpConfirmPassword.resignFirstResponder()
        tfFirstName.isHidden = arg
        tfFirstName.resignFirstResponder()
        tfLastName.isHidden = arg
        tfLastName.resignFirstResponder()
        tfBirthDate.isHidden = arg
        tfBirthDate.resignFirstResponder()
        genderPicker.isHidden = arg
    }
    
    //Displays the photo chooser
    @IBAction func btnPhotoPicker(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    //Unwind Destination for when "Logout" button is pressed from anywhere
    @IBAction func unwindToLoginMenuTest(sender: UIStoryboardSegue)
    {
        _ = sender.source
        // Pull any data from the view controller which initiated the unwind segue.
    }
    
    @objc internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            ivUserPhoto.image = pickedImage.circleMasked
            
            ivUserPhoto.isHidden = false
            
            dismiss(animated: true, completion: nil)
            
            //Upload the image
            let dm = DataManager()
            print("Chosen Image Size: \(pickedImage.size)")
            
            if pickedImage != nil {
                let imageData = UIImageJPEGRepresentation(pickedImage, 0.5)
                let base64String = imageData!.base64EncodedString(options: [])
                let item = Store.storeInstance().user
                OperationQueue.main.addOperation {
                    dm.uploadImage(userID: Int(item.id), image: "", fileName: "User\(item.id)_Image.jpg", imageData: base64String) {
                        Store.storeInstance().user.image = Store.storeInstance().image.imageURL
                        print("User\(item.id)_Image.jpg")
                        print(item.image)
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //Does not work on iOS Simulator
    @IBAction func openCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true)
        } else {
            print("camera source not available")
        }
    }
    
    func clearFields() {
        tfFirstName.text = ""
        tfLastName.text = ""
        tfSignUpEmail.text = ""
        tfSignUpConfirmEmail.text = ""
        tfSignUpPassword.text = ""
        tfSignUpConfirmPassword.text = ""
        tfBirthDate.text = ""
        tfPassword.text = ""
    }
    
    @IBAction func btnCreateAccountTouched(_ sender: UIButton) {
        if (validateAllFieldsFilled()) {
            createAccountSegue()
        }
    }
    
    func validateAllFieldsFilled() -> Bool {
        if (tfFirstName.text?.isEmpty)! ||
            (tfLastName.text?.isEmpty)! ||
            (tfSignUpEmail.text?.isEmpty)! ||
            (tfSignUpConfirmEmail.text?.isEmpty)! ||
            (tfSignUpPassword.text?.isEmpty)! ||
            (tfSignUpConfirmPassword.text?.isEmpty)! ||
            (tfBirthDate.text?.isEmpty)!{
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createAccountSegue" {
            print("Create Account Segue")
            let user = DTO_User.Create(firstName: tfFirstName.text!,
                                       lastName: tfLastName.text!,
                                       birthDate: tfBirthDate.text!,
                                       email: tfSignUpEmail.text!,
                                       pass: tfSignUpPassword.text!,
                                       gender: "\(genderPicker.selectedSegmentIndex)")
            user.image = Store.storeInstance().image.imageURL
            Store.storeInstance().user = user
            
        }
    }
    
    
}

//This extension of UIImage is the current way of getting images to be drawn as circles.
//TODO: apply antialiasing to the image or add transparent border around its edges. The
//current implementation produces images with jaggy corners
extension UIImage {
    var isPortrait: Bool { return size.height > size.width }
    var isLandscape: Bool { return size.width > size.height }
    var breadth: CGFloat { return min(size.width, size.height) }
    var breadthSize: CGSize { return CGSize(width: breadth, height: breadth) }
    var breadthRect: CGRect { return CGRect(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPortrait ? floor((size.height - size.width) / 2) : 0), size: breadthSize)) else { return nil }
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation).draw(in: breadthRect)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    //Another possiblity for getting circular images
    class func roundedRectImageFromImage(image: UIImage, imageSize: CGSize, cornerRadius: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        let bounds = CGRect(origin: .zero, size: imageSize)
        UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).addClip()
        image.draw(in: bounds)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage!
    }
    
    
    
}

extension CLPlacemark {
    
    var compactAddress: String? {
        if let name = name {
            var result = name
            
            if let street = thoroughfare {
                result += ", \(street)"
            }
            
            if let city = locality {
                result += ", \(city)"
            }
            
            if let country = country {
                result += ", \(country)"
            }
            
            return result
        }
        
        return nil
    }
    
}
