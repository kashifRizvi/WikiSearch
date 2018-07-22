//
//  DetailViewController.swift
//  WikiSearch
//
//  Created by Kashif Rizvi on 22/07/18.
//  Copyright © 2018 Kashif Rizvi. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var currentUrl: String?
    
    public static func viewController(withUrl url: String) -> DetailViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
        vc.currentUrl = url
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        webView.isHidden = true
        
        webView.navigationDelegate = self
        if let currentUrl = currentUrl, let url = URL(string: currentUrl) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        webView.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
