//
//  ViewController.swift
//  GitHub
//
//  Created by Leonard Lamprecht on 14/05/16.
//  Copyright © 2016 Leo Lamprecht. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {

    var connector: Connector = Connector()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(animated: Bool) {
        /*
        do {
            try connector.loadUser(self)
        } catch {
            fatalError(String(error))
        }*/
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("yeah")
    }
    
}
