//
//  LoginViewController.swift
//  GitHub
//
//  Created by Leonard Lamprecht on 14/05/16.
//  Copyright © 2016 Leo Lamprecht. All rights reserved.
//

import UIKit

let scopes = [
    "user",
    "public_repo",
    "repo",
    "delete_repo",
    "gist",
    "admin:repo_hook",
    "admin:org_hook",
    "admin:org",
    "admin:public_key",
    "admin:gpg_key"
]

protocol LoginViewDelegate {
    func hideView()
}

extension UIViewController {
    func hideView() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension String {
    
    func urlEncodedString() -> String {
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
    
    func parametersFromQueryString() -> Dictionary<String, String> {
        var parameters = Dictionary<String, String>()
        
        let scanner = NSScanner(string: self)
        
        var key: NSString?
        var value: NSString?
        
        while !scanner.atEnd {
            key = nil
            scanner.scanUpToString("=", intoString: &key)
            scanner.scanString("=", intoString: nil)
            
            value = nil
            scanner.scanUpToString("&", intoString: &value)
            scanner.scanString("&", intoString: nil)
            
            if let key = key as? String, let value = value as? String {
                parameters.updateValue(value, forKey: key)
            }
        }
        
        return parameters
    }
    
}

extension Dictionary {
    
    func urlEncodedQueryString() -> String {
        var parts = [String]()
        
        for (key, value) in self {
            let keyString: String = "\(key)".urlEncodedString()
            let valueString: String = "\(value)".urlEncodedString()
            let query: String = "\(keyString)=\(valueString)"
            parts.append(query)
        }
        
        return parts.joinWithSeparator("&")
    }
    
}

class LoginViewController: UIViewController, LoginViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.loginView = self
        addGradient()
        
        do {
            let request = try Connector().buildWebFlow()
            webView.loadRequest(request)
        } catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addGradient() {
        webView.backgroundColor = UIColor.clearColor()
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame.size = view.frame.size
        
        var gradientParts: [CGColor] = []
        
        let colors: [CGColor] = [
            UIColor(colorLiteralRed: 245/255, green: 245/255, blue: 245/255, alpha: 1).CGColor,
            UIColor(colorLiteralRed: 250/255, green: 250/255, blue: 250/255, alpha: 1).CGColor
        ]
        
        for (_, color) in colors.enumerate() {
            var i = 0
            
            while i < 2 {
                gradientParts.append(color)
                i += 1
            }
        }
        
        gradient.colors = gradientParts
        gradient.locations = [0, 0.5, 0.5, 1]
    
        view.layer.insertSublayer(gradient, atIndex: 0)
    }

}
