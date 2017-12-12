//
//  HobbiesTableViewController.swift
//  CollegeIOS
//
//  Created by Joseph Rudeseal on 11/29/17.
//  Copyright © 2017 Jerry Hill. All rights reserved.
//

import Foundation
import UIKit

class HobbiesTableViewController: UITableViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    var hobby: String = ""
    var hobbies: [String?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        for index in 0...tableView.numberOfRows(inSection: 0) - 1 {
            let indexPath = NSIndexPath(row: index, section: 0)
            let cell = tableView.cellForRow(at: indexPath as IndexPath)!
            let tfHobby = cell.viewWithTag(2000) as! UITextField
            print(tfHobby.text!)
            Store.storeInstance().user.hobbies[index] = tfHobby.text!
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Store.storeInstance().user.hobbies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HobbyCell", for: indexPath)
        
        let hobbyItem = Store.storeInstance().user.hobbies[indexPath.row]
        
        let tfHobby = cell.viewWithTag(2000) as! UITextField
        tfHobby.delegate = self
        tfHobby.text = hobbyItem
        return cell
    }
    
    @IBAction func addHobby(_ sender: UIBarButtonItem) {
        Store.storeInstance().user.hobbies.append("")
        tableView.reloadData()
    }
    @IBAction func removeHobby(_ sender: UIButton) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            Store.storeInstance().user.hobbies.remove(at: indexPath.row)
        }
        tableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
