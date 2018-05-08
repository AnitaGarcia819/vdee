//
//  FBFeedViewController.swift
//  vdee
//
//  Created by Nicholas Rosas on 4/5/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

import UIKit

class FBFeedViewController: UIViewController, UIWebViewDelegate {

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    static let FBGroupURL = "https://facebook.com/EValverdeSr/"

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self

        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack))
        self.navigationItem.setLeftBarButton(barButtonItem, animated: true)
        loadFBGroupWeb()
    }
    
    func goBack() {
        if (webView.canGoBack) {
            webView.goBack()
        }
    }
    
    func loadFBGroupWeb() {
        let url = URL(string: FBFeedViewController.FBGroupURL)
        if let unwrappedURL = url {
            let request = URLRequest(url: unwrappedURL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    
                    self.webView.loadRequest(request)
                }
            }
            task.resume()
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        if !activityIndicator.isAnimating {
            activityIndicator.startAnimating()
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
