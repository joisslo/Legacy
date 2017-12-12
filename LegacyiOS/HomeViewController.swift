//
//  HomeViewController.swift
//  CollegeIOS
//
//  Created by Joseph Rudeseal on 11/15/17.
//  Copyright © 2017 Jerry Hill. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var suggestedCollection: UICollectionView!
    @IBOutlet weak var adminCollection: UICollectionView!
    @IBOutlet weak var btnUserImage: UIButton!
    @IBOutlet weak var lblUserFirstName: UILabel!
    
    var defaultFirstName: String = "Joseph"
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var geocoder: CLGeocoder?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        suggestedCollection?.delegate = self
        suggestedCollection?.dataSource = self
        adminCollection?.delegate = self
        adminCollection?.dataSource = self
        lblUserFirstName.text = "Hello, \(Store.storeInstance().user.first_name)"
        
        let dm = DataManager()
        //        dm.loadAllData() { () in OperationQueue.main.addOperation {
        //                print("Suggested Collection Load Finished")
        //                self.suggestedCollection?.reloadData()
        //                self.adminCollection?.reloadData()
        //
        //            }
        //        }
        dm.loadAllPolitics() { () in OperationQueue.main.addOperation {
            print("Loaded Politics From Service")
            }
        }
        dm.loadAllReligions() { () in OperationQueue.main.addOperation {
            print("Loaded Religions from service")
            }
        }
        dm.loadAllStates() { () in OperationQueue.main.addOperation {
            print("Loaded States from external service")
            }
        }
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if (authorizationStatus == CLAuthorizationStatus.notDetermined) {
            locationManager?.requestWhenInUseAuthorization()
        } else {
            locationManager?.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblUserFirstName.text = "Hello, \(Store.storeInstance().user.first_name)"
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(Store.storeInstance().campuses.count)
        return(Store.storeInstance().campuses.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCell
        let item = Store.storeInstance().campuses[indexPath.item]
        //Store.storeInstance().student = item
        
        let label = cell.viewWithTag(2000) as! UILabel
        let imageView = cell.viewWithTag(2001) as! UIImageView
        
        //label.text = "\(item.CampusName)"
        imageView.image = getRandomUserPicture()
        
        return cell
    }
    
    
    @objc private func refreshCollectionData(_ sender: Any) {
        fetchData()
    }
    
    private func fetchData() {
        suggestedCollection.delegate = self
        adminCollection.delegate = self
        let dm = DataManager()
        dm.loadAllData() { () in OperationQueue.main.addOperation {
            print("load finished")
            self.suggestedCollection.reloadData()
            self.adminCollection.reloadData()
            }
            //refreshControl.activityIndicatorView.stopAnimating()
        }
    }
    
    func locationManager(_ manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        currentLocation = locations[locations.count - 1] as? CLLocation
        print("Locations =  \(currentLocation)")
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewProfileFromSuggested" {
            print("View Profile from the suggested legacies list")
            let detailsVC = segue.destination as! ProfileViewController
            let cell = sender as! UserCell
            let indexPath = suggestedCollection.indexPath(for: cell)
            let campus = Store.storeInstance().campuses[indexPath!.row]
            detailsVC.userPhoto = cell.suggestedImageView.image
        } else if segue.identifier == "viewProfileFromUserPhoto" {
            print("View Profile from tapping the user photo")
            let detailsVC = segue.destination as! ProfileViewController
            detailsVC.userPhoto = btnUserImage.currentImage
            //Should Get the user's firstname
            //detailsVC.userName = lblUserFirstName.text
            detailsVC.userName = defaultFirstName
            //detailsVC.userPhoto = btnUserImage.imageView?.image
        } else if segue.identifier == "editProfileFromLegacyAdminList" {
            print("Edit Profile from the Legacy Admin List")
            let detailsVC = segue.destination as! EditProfileViewController
            let cell = sender as! UserCell
            let indexPath = adminCollection.indexPath(for: cell)
            let campus = Store.storeInstance().campuses[indexPath!.row]
            detailsVC.userPhoto = cell.adminImageView.image
            //detailsVC.campus = campus
        } else if segue.identifier == "editProfileFromNavButton" {
            print("Edit Profile from the Navigation Button")
            print("View Profile from tapping the user photo")
            let detailsVC = segue.destination as! EditProfileViewController
            detailsVC.userPhoto = btnUserImage.currentImage
            //Should Get the user's firstname
            //detailsVC.userName = lblUserFirstName.text
            detailsVC.userName = defaultFirstName
            //detailsVC.userPhoto = btnUserImage.imageView?.image
        }
    }
}
