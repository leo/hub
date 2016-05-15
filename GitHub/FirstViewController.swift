//
//  FirstViewController.swift
//  GitHub
//
//  Created by Leonard Lamprecht on 14/05/16.
//  Copyright © 2016 Leo Lamprecht. All rights reserved.
//

import UIKit

class FirstViewController: UITableViewController {

    var connector: Connector = Connector()
    var repos: AnyObject?

    @IBOutlet var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try connector.loadDataOfCurrentUser("repos") { (data: AnyObject) in
                self.repos = data
            }
        } catch {
            fatalError(String(error))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    /*
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (repos?.count)!
    }*/

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath)

        print(self.repos)

        //cell.textLabel!.text = repos[indexPath.row]
        return cell
    }

}

