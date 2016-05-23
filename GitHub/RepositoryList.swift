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
    var errorMessage: UITextView?

    @IBOutlet weak var refresher: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData(nil)

        tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(RepositoryListController.someAction))
        navigationItem.rightBarButtonItem = button
    }

    func loadData(sender: UIRefreshControl?) {
        do {
            try connector.loadDataOfCurrentUser("repos") { (data: AnyObject) in
                self.repos = data

                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    self.errorMessage?.hidden = true

                    if sender != nil {
                        sender?.endRefreshing()
                    }
                })
            }
        } catch {
            fatalError(String(error))
        }
    }

    @IBAction func refresh(sender: UIRefreshControl) {
        loadData(sender)
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
        errorMessage = UITextView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))

        errorMessage?.text = "No data available.\nPlease pull down to refresh."
        errorMessage?.textColor = UIColor.grayColor()
        errorMessage?.textAlignment = NSTextAlignment.Center
        errorMessage?.font = UIFont.systemFontOfSize(19)
        errorMessage?.editable = false

        var topOffset: CGFloat = (errorMessage!.bounds.size.height - errorMessage!.contentSize.height * errorMessage!.zoomScale) / 2.0

        topOffset = topOffset < 0.0 ? 0.0 : topOffset
        topOffset -= refresher.bounds.height

        errorMessage?.contentOffset = CGPoint(x: 0, y: -topOffset)

        if let list: NSArray = self.repos as? NSArray {
            errorMessage?.hidden = true
            return list.count
        } else {
            tableView.addSubview(errorMessage!)
        }

        return 0
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let list: NSArray = self.repos as? NSArray else {
            fatalError()
        }

        let details = list[indexPath.row]

        performSegueWithIdentifier("showRepoDetails", sender: details)
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

        var imageName = "Normal"

        if currentItem["fork"] as! Bool == true {
            imageName = "Fork"
        }

        if currentItem["private"] as! Bool == true {
            cell.backgroundColor = UIColor(red: 1.00, green: 0.98, blue: 0.92, alpha: 1.00)
            imageName = "Private"
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }

        let image: UIImage = UIImage(named: imageName)!
        cell.imageView?.image = image

        return cell
    }

}

