//
//  SearchViewController.swift
//  CollegeIOS
//
//  Created by Joseph Rudeseal on 11/15/17.
//  Copyright © 2017 Jerry Hill. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    let refreshControl = UIRefreshControl()
    var indicator = UIActivityIndicatorView()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        tableView?.delegate = self
        searchBar?.delegate = self

        let dm = DataManager()
        dm.loadAllData() { () in OperationQueue.main.addOperation {
                print("Search Table Load Finished")
                self.tableView?.reloadData()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
        print("Number of search view rows: ", Store.storeInstance().campuses.count)
        return Store.storeInstance().campuses.count
    }

    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "LegacyCell", for: indexPath)

        let item = Store.storeInstance().campuses[indexPath.row]
        //Store.storeInstance().student = item
        let label = cell.viewWithTag(1000) as! UILabel
        let imageView = cell.viewWithTag(1001) as! UIImageView

        // imageView.downloadedFrom(link: item.pic)

        //label.text = "\(item.CampusName)"
        imageView.image = #imageLiteral(resourceName: "bill_gates.jpg").circleMasked
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
        dm.loadAllData() { () in OperationQueue.main.addOperation {
                print("load finished")
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
}
