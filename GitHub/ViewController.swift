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

        do {
            try connector.loadUser(insertData)
        } catch {
            fatalError(String(error))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(animated: Bool) {

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        insertData(sender as! [String : AnyObject])
    }

    func insertData(data: [String : AnyObject]) {
        print(data)
    }
    
}
