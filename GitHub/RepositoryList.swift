//
//  FirstViewController.swift
//  GitHub
//
//  Created by Leonard Lamprecht on 14/05/16.
//  Copyright © 2016 Leo Lamprecht. All rights reserved.
//

import UIKit

class RepositoryListController: UITableViewController {

    var connector: Connector = Connector()
    var repos: [AnyObject]?

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try connector.loadDataOfCurrentUser("repos") { (data: [AnyObject]) in
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

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*
        guard let list = self.repos else {
            fatalError()
        }*/

        //print(self.repos)

        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath)

        //cell.textLabel!.text = repos[indexPath.row]
        cell.textLabel!.text = "Haha"
        return cell
    }

}

