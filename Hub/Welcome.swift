//
//  WelcomeViewController.swift
//  Hub
//
//  Created by Leo Lamprecht on 14/05/16.
//  Copyright © 2016 Leo Lamprecht. All rights reserved.
//

import UIKit
import SafariServices

protocol WelcomeViewDelegate {
    func hideView()
    func performSegueWithIdentifier(identifier: String, sender: AnyObject?)

    var safariView: SFSafariViewController? { get set }
}

class WelcomeViewController: UIViewController, WelcomeViewDelegate {
    
    @IBOutlet weak var submitButton: UIButton!

    let connector: Connector = Connector()
    var safariView: SFSafariViewController?
    var webFlowUrl: NSURL?

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.welcomeView = self

        do {
            let url = try connector.buildWebFlow()
            webFlowUrl = url
        } catch {
            fatalError(String(error))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func loginButtonTapped() {
        guard let url = webFlowUrl else {
            return
        }

        safariView = SFSafariViewController(URL: url)
        presentViewController(safariView!, animated: true, completion: nil)
    }

}
