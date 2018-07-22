//
//  SearchListViewController.swift
//  WikiSearch
//
//  Created by Kashif Rizvi on 22/07/18.
//  Copyright © 2018 Kashif Rizvi. All rights reserved.
//

import UIKit

class SearchListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let searchManager = SearchManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchManager.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchListCell", for: indexPath) as! SearchListCell
        cell.titleLabel.text = searchManager.results[indexPath.row].title
        cell.detailTextLabel?.text = searchManager.results[indexPath.row].description
        if let urlString = searchManager.results[indexPath.row].imageURL {
            cell.imageView?.image = UIImage(data: try! Data(contentsOf: URL(string: urlString)!))
        }
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
