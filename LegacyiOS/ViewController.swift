//
//  ViewController.swift
//  CollegeIOS
//
//  Created by Jerry Hill on 2/19/17.
//  Copyright © 2017 Jerry Hill. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.delegate = self
        let dm = DataManager()
        
        dm.loadAllData()
            {
                () in
                OperationQueue.main.addOperation
                    {
                        
                        print("load finished")
                        
                        self.tableView.reloadData()
                }
                
        }
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int
    {
        print(Store.storeInstance().campuses.count)
        return Store.storeInstance().campuses.count
    }
    
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "StudentCell", for: indexPath)
        
        let item = Store.storeInstance().campuses[indexPath.row]
        //Store.storeInstance().student = item
        let label = cell.viewWithTag(1000) as! UILabel
        //let imageView = cell.viewWithTag(1001) as! UIImageView
        
        // imageView.downloadedFrom(link: item.pic)
        
        label.text = "\(item.authorName)"
        
        return cell
    }
    
    
}
