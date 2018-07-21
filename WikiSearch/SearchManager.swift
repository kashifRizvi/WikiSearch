//
//  SearchManager.swift
//  WikiSearch
//
//  Created by Kashif Rizvi on 22/07/18.
//  Copyright © 2018 Kashif Rizvi. All rights reserved.
//

import Foundation

public class SearchManager {
    
    var results = [SearchResult]()
    var cacheQueue = OperationQueue()
    var cacheDict: [String: Any]?
    
    var searchCacheUrl: URL? {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("searchResults.json")
    }
    
    let baseUrl = "https://en.wikipedia.org//w/api.php"
    fileprivate(set) var defaultParams: [String: Any] = ["action": "query",
                                                                      "format": "json",
                                                                      "prop": "pageimages|pageterms",
                                                                      "generator": "prefixsearch",
                                                                      "redirects": true,
                                                                      "formatversion": 2,
                                                                      "piprop": "thumbnail",
                                                                      "pithumbsize": 100,
                                                                      "pilimit": 10,
                                                                      "wbptterms": "description",
                                                                      "gpslimit": 10]
    
    init() {
        cachedResults()
    }
    
    func searchResults(input: String) {
        defaultParams["gpssearch"] = input as AnyObject
        
        let params = defaultParams.keys.map{"\($0)=\(defaultParams[$0] ?? "" as AnyObject)"}.joined(separator: "&")
        
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: baseUrl)!)
        
        request.httpMethod = "POST"
        request.httpBody = params.data(using: .utf8)
        
        session.dataTask(with: request) { (data, response, error) in
            
            if data != nil, error == nil {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        self.populateResults(responseDict: json)
                        
                        if let searchCacheUrl = self.searchCacheUrl {
                            self.cacheQueue.addOperation {
                                if let stream = OutputStream(url: searchCacheUrl, append: false) {
                                    stream.open()
                                    JSONSerialization.writeJSONObject(json, to: stream, options: [.prettyPrinted], error: nil)
                                    stream.close()
                                }
                            }
                        }
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
    
    func cachedResults() {
        if let searchCacheUrl = searchCacheUrl {
            cacheQueue.addOperation() {
                if let stream = InputStream(url: searchCacheUrl) {
                    stream.open()
                    self.cacheDict = (try? JSONSerialization.jsonObject(with: stream, options: .allowFragments)) as? [String: Any]
                    self.populateResults(responseDict: self.cacheDict)
                    stream.close()
                }
            }
        }
    }
    
    func populateResults(responseDict: [String: Any]?) {
        if let query = responseDict?["query"] as? [String: AnyObject], let pages = query["pages"] as? [[String: AnyObject]] {
            _ = pages.map { row in
                var searchResult: SearchResult!
                if let pageId = row["pageid"] as? Int64, let title = row["title"] as? String, let index = row["index"] as? Int {
                    searchResult = SearchResult(title: title, index: index, pageId: pageId)
                    if let terms = row["terms"] as? [String: AnyObject], let description = terms["description"] as? [String] {
                        let description = description.map{$0} .joined(separator: "&")
                        searchResult.description = description
                    }
                    if let thumbnail = row["thumbnail"] as? [String: AnyObject], let source = thumbnail["source"] as? String {
                        searchResult.imageURL = source
                    }
                    self.results.append(searchResult)
                }
            }
        }
    }
    
    
}
