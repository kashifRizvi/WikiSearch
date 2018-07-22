//
//  SearchListViewController.swift
//  WikiSearch
//
//  Created by Kashif Rizvi on 22/07/18.
//  Copyright © 2018 Kashif Rizvi. All rights reserved.
//

import UIKit

class SearchListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let searchManager = SearchManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        searchBar.delegate = self
        
        activityIndicator.startAnimating()
        tableView.isHidden = true
        
        searchManager.completion = {
            OperationQueue.main.addOperation {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchManager.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cachedResult = searchManager.results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchListCell", for: indexPath) as! SearchListCell
        cell.titleLabel.text = cachedResult.title
        cell.descriptionLabel?.text = cachedResult.description
        cell.titleImage.image = cachedResult.image ?? UIImage(named: "placeholder-user")
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let fullurl = searchManager.results[indexPath.row].fullUrl {
            let detailVC = DetailViewController.viewController(withUrl: fullurl)
            navigationController?.pushViewController(detailVC, animated: true)
        }
        else {
            let alertController = UIAlertController(title: "No link available", message: "Extra information is not available for this result", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(action)
            alertController.show(self, sender: nil)
        }
    }
    
}
