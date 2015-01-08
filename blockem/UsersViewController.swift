//
//  UserViewController
//  blockem
//
//  Created by Manuel Deschamps on 1/6/15.
//  Copyright (c) 2015 Manuel Deschamps. All rights reserved.
//

import UIKit
import TwitterKit

class UsersViewController: UITableViewController {
    
    var users: [TWTRUser] = [] {
        didSet {
            tableView.reloadData()
            viewTitle = viewLabel + ": " + String(users.count)
            
            progressBar.hidden = true
            navigationItem.rightBarButtonItems?.append(nextButton)
        }
    }
    
    var viewLabel: String!
    var viewTitle: String = "" {
        didSet {
            self.navigationController?.navigationBar.topItem?.title = viewTitle
        }
    }
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet var nextButton: UIBarButtonItem!
    
    var prototypeCell: TWTRUserTableViewCell?
    
    let userTableCellReuseIdentifier = "TWTRUserTableViewCell"
    
    var isLoadingUsers = false
    
    func initViewController() {
        // Setup the table view.
        self.tableView.estimatedRowHeight = 78
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.allowsSelection = false
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        // Create a single prototype cell for height calculations.
        self.prototypeCell = TWTRUserTableViewCell(style: .Default, reuseIdentifier: userTableCellReuseIdentifier)
        
        self.tableView.registerNib(UINib(nibName: userTableCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: userTableCellReuseIdentifier)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        self.progressBar.hidden = false
        self.navigationItem.rightBarButtonItems?.removeLast()
    }
    
    internal func setProgress(progress: Float, total: Float) {
        self.progressBar.setProgress(total / progress, animated: false)
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of Tweets.
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> TWTRUserTableViewCell {
        // Retrieve the Tweet cell.
        let cell = tableView.dequeueReusableCellWithIdentifier(userTableCellReuseIdentifier, forIndexPath: indexPath) as TWTRUserTableViewCell
        
        // Retrieve the Tweet model from loaded Tweets.
        let user = self.users[indexPath.row]
        
        // Configure the cell with the Tweet.
        cell.configureWithUser(user)
        
        // Return the Tweet cell.
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let user = self.users[indexPath.row]
        return self.tableView.estimatedRowHeight
    }
}
