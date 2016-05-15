//
//  ViewController.swift
//  GitHub
//
//  Created by Leonard Lamprecht on 14/05/16.
//  Copyright © 2016 Leo Lamprecht. All rights reserved.
//

import UIKit

protocol MainDelegate {
    func generateList(data: [String:AnyObject])
}

class ViewController: UITabBarController, MainDelegate {

    var connector: Connector = Connector()

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.mainView = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(animated: Bool) {
        do {
            try connector.loadUser(self)
        } catch {
            fatalError(String(error))
        }
    }
    
    func generateList(data: [String:AnyObject]) {
        print(data)
    }
    
}
