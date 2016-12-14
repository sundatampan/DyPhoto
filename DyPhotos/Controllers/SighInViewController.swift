//
//  SighInViewController.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 11/11/15.
//  Copyright © 2015 DyCode. All rights reserved.
//

import UIKit

class SighInViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    let authorizationURL = "https://instagram.com/oauth/authorize/?client_id=\(CLIENT_ID)&redirect_uri=\(REDIRECT_URI)&response_type=token"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        if let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies {
            for cookie in cookies {
                NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
            }
        }
        
        if let url = NSURL(string: authorizationURL) {
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - UIWebViewDelegate
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if let urlString = request.URL?.absoluteString {
            if (urlString.rangeOfString("\(REDIRECT_URI)#access_token=") != nil) {
                if let accessToken = urlString.componentsSeparatedByString("=").last {
                    
                    NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: kAccessTokenKey)
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.showMainViewController()
                    
                    return false
                }
            }
        }
        
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        
        webView.alpha = 0.2
        activityIndicatorView.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        webView.alpha = 1.0
        activityIndicatorView.stopAnimating()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        
        webView.alpha = 1.0
        activityIndicatorView.stopAnimating()
    }
}
