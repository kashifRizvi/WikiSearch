//
//  SearchResult.swift
//  WikiSearch
//
//  Created by Kashif Rizvi on 22/07/18.
//  Copyright © 2018 Kashif Rizvi. All rights reserved.
//

import Foundation
import UIKit

class SearchResult {
    var imageURL: String?
    var title: String
    var index: Int
    var description: String?
    var pageId: Int64
    var fullUrl: String?
    var image: UIImage?
    
    init(title: String, index: Int, description: String? = "", pageId: Int64, imageUrl: String? = nil) {
        self.title = title
        self.description = description
        self.pageId = pageId
        self.index = index
        self.imageURL = imageUrl
    }
}
