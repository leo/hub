//
//  ViewController.swift
//  GitHub
//
//  Created by Leonard Lamprecht on 14/05/16.
//  Copyright © 2016 Leo Lamprecht. All rights reserved.
//

import UIKit

class ViewController: UITabBarController, LoginViewControllerDelegate {
    
    var loggedIn: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        if loggedIn == false {
            performSegueWithIdentifier("showLogin", sender: nil)
        }
    }
    
    func didLoginSuccessfully() {
        loggedIn = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showLogin" {
            let loginVC = segue.destinationViewController as! LoginViewController
            loginVC.delegate = self
        }
    }
}
