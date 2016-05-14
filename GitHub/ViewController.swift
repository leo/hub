//
//  ViewController.swift
//  GitHub
//
//  Created by Leonard Lamprecht on 14/05/16.
//  Copyright © 2016 Leo Lamprecht. All rights reserved.
//

import UIKit

protocol MainDelegate {
    func didLogin()
}

class ViewController: UITabBarController, MainDelegate {
    
    var loggedIn: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.mainView = self
    }
    
    deinit {
        events.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(animated: Bool) {
        if loggedIn == false {
            performSegueWithIdentifier("showWelcome", sender: nil)
        }
    }
    
    func didLogin() {
        loggedIn = true
    }
    
}
