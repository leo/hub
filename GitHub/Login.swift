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
