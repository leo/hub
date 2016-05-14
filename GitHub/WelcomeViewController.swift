//
//  WelcomeViewController.swift
//  GitHub
//
//  Created by Leonard Lamprecht on 14/05/16.
//  Copyright © 2016 Leo Lamprecht. All rights reserved.
//

import UIKit

protocol WelcomeViewDelegate {
    func hideView()
}

class WelcomeViewController: UIViewController, WelcomeViewDelegate {
    
    @IBOutlet weak var submitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.welcomeView = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func loginButtonTapped() {
        performSegueWithIdentifier("showLogin", sender: nil)
    }

}
