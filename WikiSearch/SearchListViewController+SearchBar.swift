//
//  SearchListViewController+SearchBar.swift
//  WikiSearch
//
//  Created by Kashif Rizvi on 22/07/18.
//  Copyright © 2018 Kashif Rizvi. All rights reserved.
//

import Foundation
import UIKit

extension SearchListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        tableView.isHidden = true
        searchManager.searchResults(input: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
    
}
