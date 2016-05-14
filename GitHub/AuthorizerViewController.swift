//
//  AuthorizerViewController.swift
//  GitHub
//
//  Created by Leonard Lamprecht on 14/05/16.
//  Copyright © 2016 Leo Lamprecht. All rights reserved.
//

import UIKit

extension String {
    func urlEncodedStringWithEncoding() -> String {
        let allowedCharacterSet = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
        allowedCharacterSet.removeCharactersInString("\n:#/?@!$&'()*+,;=")
        allowedCharacterSet.addCharactersInString("[]")
        return self.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet)!
    }
    
    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.characters.count))
            randomString += "\(base[base.startIndex.advancedBy(Int(randomValue))])"
        }
        
        return randomString
    }
}

extension Dictionary {
    func urlEncodedQueryStringWithEncoding() -> String {
        var parts = [String]()
        
        for (key, value) in self {
            let keyString: String = "\(key)".urlEncodedStringWithEncoding()
            let valueString: String = "\(value)".urlEncodedStringWithEncoding()
            let query: String = "\(keyString)=\(valueString)"
            parts.append(query)
        }
        
        return parts.joinWithSeparator("&")
    }
}

class AuthorizerViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.scrollView.scrollEnabled = false
        webView.scrollView.bounces = false
        
        let urlParts: [String:String] = [
            "client_id": "0fe88ac59c5d6d50642a",
            "redirect_uri": "github://authenticated",
            "state": String.random()
        ]
        
        let urlString = "https://github.com/login/oauth/authorize?" + urlParts.urlEncodedQueryStringWithEncoding()
        let url = NSURL (string: urlString)
        let requestObj = NSURLRequest(URL: url!)
        
        webView.loadRequest(requestObj)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
