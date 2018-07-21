//
//  SearchManager.swift
//  WikiSearch
//
//  Created by Kashif Rizvi on 22/07/18.
//  Copyright © 2018 Kashif Rizvi. All rights reserved.
//

import Foundation

public class SearchManager {
    
    static let baseUrl = "https://en.wikipedia.org//w/api.php"
    static fileprivate(set) var defaultParams: [String: AnyObject] = ["action": "query" as AnyObject,
                                                                      "format": "json" as AnyObject,
                                                                      "prop": "pageimages|pageterms" as AnyObject,
                                                                      "generator": "prefixsearch" as AnyObject,
                                                                      "redirects": true as AnyObject,
                                                                      "formatversion": 2 as AnyObject,
                                                                      "piprop": "thumbnail" as AnyObject,
                                                                      "pithumbsize": 100 as AnyObject,
                                                                      "pilimit": 10 as AnyObject,
                                                                      "wbptterms": "description" as AnyObject,
                                                                      "gpslimit": 10 as AnyObject]
    
    
    static func searchResults(input: String) {
        defaultParams["gpssearch"] = input as AnyObject
        
        let params = defaultParams.keys.map{"\($0)=\(defaultParams[$0] ?? "" as AnyObject)"}.joined(separator: "&")
        
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: baseUrl)!)
        
        request.httpMethod = "POST"
        request.httpBody = params.data(using: .utf8)
        
        session.dataTask(with: request) { (data, response, error) in
            
            if data != nil, error == nil {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any], let query = json["query"] as? [String: AnyObject], let pages = query["pages"] as? [AnyObject] {
                        
                        
                        print(pages)
                    }
                }
                catch let error {
                    print(error.localizedDescription)
                }
            }
            else {
                print(error?.localizedDescription)
            }
            
        }.resume()
        
    }
    
    
}
