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
    var repos: AnyObject?

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try connector.loadDataOfCurrentUser("repos") { (data: AnyObject) in
                self.repos = data

                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        } catch {
            fatalError(String(error))
        }

        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(RepositoryListController.someAction))
        navigationItem.rightBarButtonItem = button
    }

    func someAction() {
        print("yeah")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.repos == nil) {
            return 0
        }

        guard let list: NSArray = self.repos as? NSArray else {
            fatalError()
        }

        return list.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath)

        guard let list: NSArray = self.repos as? NSArray else {
            fatalError()
        }

        let currentItem = list[indexPath.row]

        guard let name = currentItem["full_name"], let stars = currentItem["stargazers_count"]! else {
            fatalError()
        }

        var detailLabel: String? = nil

        if (String(stars) != "0") {
            detailLabel = String(stars) + " \u{2605}"
        }

        cell.detailTextLabel?.text = detailLabel
        cell.textLabel!.text = name as? String

        return cell
    }

}

