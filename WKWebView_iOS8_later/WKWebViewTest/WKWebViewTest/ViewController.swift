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
        webView.navigationDelegate = self
        view = webView
        // create the url-request
        let urlString = "https://floating-cliffs-24541.herokuapp.com"
        let request = NSMutableURLRequest(url: URL(string: urlString)!)
        
        // set the method(HTTP-POST)
        request.httpMethod = "POST"
        // set the header(s)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("RBD", forHTTPHeaderField: "X-APP")
        request.addValue("1", forHTTPHeaderField: "version")
        
        // set the request-body(JSON)
        let params: [String: String] = [
            "post-text": "test"
        ]
        request.httpBody = try! JSONSerialization.data(withJSONObject: params)
        
        taskExcute(request: request as URLRequest)
        //webView.load(request as URLRequest)
    }
    
    fileprivate func taskExcute(request: URLRequest) {
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {data, response, error in
            if (error == nil) {
                let result = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                DispatchQueue.main.async {
                    self.webView.loadHTMLString(result as String, baseURL: request.url)
                }
            }
        })
        task.resume()
    }
}

extension ViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {

        guard let _ = navigationAction.request.allHTTPHeaderFields?["RBD"] else {
            var request = navigationAction.request
            request.addValue("RBD", forHTTPHeaderField: "X-APP")
            request.addValue("1", forHTTPHeaderField: "version")
            taskExcute(request: request as URLRequest)
            return decisionHandler(.cancel)
        }
        return decisionHandler(.allow)
    }
}
