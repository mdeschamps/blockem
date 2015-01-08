//
//  FollowersViewController.swift
//  blockem
//
//  Created by Manuel Deschamps on 1/6/15.
//  Copyright (c) 2015 Manuel Deschamps. All rights reserved.
//

import UIKit
import TwitterKit

class FollowersViewController: UsersViewController {
    
    var user: TWTRUser!
    var rawUser: NSDictionary!
    var friends: [TWTRUser]!
    
    override func viewDidLoad() {
        self.viewLabel = "Followers"
        
        super.viewDidLoad()
        
        // Setup the table view.
        initViewController()
        
        self.loadFollowers()
    }
    
    internal func loadFollowers() {
        // Do not trigger another request if one is already in progress.
        if self.isLoadingUsers {
            return
        }
        self.isLoadingUsers = true
        self.progressBar.setProgress(0, animated: false)
        
        // Search for poems on Twitter by performing an API request.
        Twitter.sharedInstance().APIClient.listFollowers(
            progress: { usersLoaded in
                self.viewTitle = "Loading followers..."
                
                let followersCount = self.rawUser["followers_count"] as Float
                self.setProgress(followersCount, total: Float(usersLoaded))
            },
            completion: { usersResult in
                switch usersResult {
                case let .Users(usersResult):
                    // Add Users objects from the JSON data.
                    self.users = usersResult
                    self.viewTitle = "Followers: " + String(self.users.count)
                    
                    self.progressBar.hidden = true
                case let .Error(error):
                    println("Error searching tweets: \(error)")
                }
                
                // Update the boolean since we are no longer loading Tweets.
                self.isLoadingUsers = false
        })
    }
}
