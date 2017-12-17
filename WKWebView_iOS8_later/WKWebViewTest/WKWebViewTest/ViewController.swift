//
//  ViewController.swift
//  WKWebViewTest1
//
//  Created by 酒井邦也 on 2017/12/17.
//  Copyright © 2017年 酒井邦也. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
        // create the url-request
        let urlString = "https://floating-cliffs-24541.herokuapp.com"
        let request = NSMutableURLRequest(url: URL(string: urlString)!)
        
        // set the method(HTTP-POST)
        request.httpMethod = "POST"
        // set the header(s)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // set the request-body(JSON)
        let params: [String: String] = [
            "post-text": "test"
        ]
        request.httpBody = try! JSONSerialization.data(withJSONObject: params)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {data, response, error in
            if (error == nil) {
                let result = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                DispatchQueue.main.async {
                    //                    self.webView.loadHTMLString(result as String, baseURL: request.url)
                }
            }
        })
        task.resume()
        webView.load(request as URLRequest)
    }
}

extension ViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        
    }
}
