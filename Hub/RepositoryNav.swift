//
//  RepositoryList.swift
//  Hub
//
//  Created by Leo Lamprecht on 16/05/16.
//  Copyright © 2016 Leo Lamprecht. All rights reserved.
//

import UIKit

class RepositoryNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.topItem?.title = "Repositories"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(animated: Bool) {
        
    }

}
