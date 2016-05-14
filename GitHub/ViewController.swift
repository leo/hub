//
//  ViewController.swift
//  GitHub
//
//  Created by Leonard Lamprecht on 14/05/16.
//  Copyright © 2016 Leo Lamprecht. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {
    
    var loggedIn: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(animated: Bool) {
        if loggedIn == false {
            performSegueWithIdentifier("showWelcome", sender: nil)
        }
    }
    
    func didLoginSuccessfully() {
        loggedIn = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
