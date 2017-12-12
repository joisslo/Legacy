//
//  MessagesViewController.swift
//  CollegeIOS
//
//  Created by Joseph Rudeseal on 12/6/17.
//  Copyright © 2017 Jerry Hill. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let refreshControl = UIRefreshControl()
    var indicator = UIActivityIndicatorView()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView?.delegate = self
        let dm = DataManager()
        
        dm.loadAllMessages() { () in OperationQueue.main.addOperation {
            print("Loaded Messages from legacy service")
            self.tableView?.reloadData()
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
        //Configure Refresh Control
        refreshControl.tintColor = UIColor(red: 0.25, green: 0.72, blue: 0.85, alpha: 1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl.addTarget(self, action: #selector(refreshTableData(_:)), for: .valueChanged)
        
        //Add Refresh Control
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        print(Store.storeInstance().messages.count)
        return Store.storeInstance().messages.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "MessageCell", for: indexPath)
        
        let item = Store.storeInstance().messages[indexPath.row]
        //Store.storeInstance().student = item
        let label = cell.viewWithTag(1000) as! UILabel
        let imageView = cell.viewWithTag(1001) as! UIImageView
        
        // imageView.downloadedFrom(link: item.pic)
        cell.imageView?.image = #imageLiteral(resourceName: "userPic.png")
        label.text = "\(item.authorName): \(item.message)"
        //imageView.image = getRandomUserPicture().circleMasked
        return cell
    }
    
    @objc private func refreshTableData(_ sender: Any) {
        fetchData()
    }
    
    private func fetchData() {
        tableView.delegate = self
        let dm = DataManager()
        
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.white
        dm.loadAllMessages() { () in OperationQueue.main.addOperation {
            print("Refreshed messages")
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
            self.tableView.reloadData()
            }
            self.refreshControl.endRefreshing()
            //refreshControl.activityIndicatorView.stopAnimating()
        }
    }
    
    func activityIndicator() {
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "messagesSegue" {
            print("Message Detail View")
            let detailsVC = segue.destination as! MessagesDetailViewController
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let message = Store.storeInstance().messages[indexPath!.row]
            detailsVC.userPhoto = cell.imageView?.image
            print(cell.imageView?.image)
            detailsVC.message = message
        }
    }
}
