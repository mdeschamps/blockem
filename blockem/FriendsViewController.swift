//
//  FriendsViewController.swift
//  blockem
//
//  Created by Manuel Deschamps on 1/6/15.
//  Copyright (c) 2015 Manuel Deschamps. All rights reserved.
//

import UIKit
import TwitterKit

class FriendsViewController: UsersViewController {

    var user: TWTRUser!
    var rawUser: NSDictionary!
        
    override func viewDidLoad() {
        self.viewLabel = "Friends"
        
        super.viewDidLoad()
        
        // Setup the table view.
        initViewController()
        
        // Load the logged-in user
        verifyCredentails()
    }
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let followersView = segue.destinationViewController as? FollowersViewController {
            followersView.user = self.user
            followersView.rawUser = self.rawUser
            followersView.friends = self.users
        }
    }
    
    internal func verifyCredentails() {
        Twitter.sharedInstance().APIClient.verifyCredentials() { user, rawUser in
            // save values
            self.user = user
            self.rawUser = rawUser
            
            // fire Request
            self.loadFriends()
        }
    }
    
    internal func loadFriends() {
        // Do not trigger another request if one is already in progress.
        if self.isLoadingUsers {
            return
        }
        self.isLoadingUsers = true
        
        self.progressBar.setProgress(0, animated: false)
        
        // Search for poems on Twitter by performing an API request.
        Twitter.sharedInstance().APIClient.listFriends(
            progress: { usersLoaded in
                self.viewTitle = "Loading friends..."
                let followersCount = self.rawUser["friends_count"] as Float
                self.setProgress(followersCount, total: Float(usersLoaded))
            },
            completion: { usersResult in
                switch usersResult {
                case let .Users(usersResult):
                    self.users = usersResult
                    
                case let .Error(error):
                    println("Error searching tweets: \(error)")
                }
                
                // Update the boolean since we are no longer loading Tweets.
                self.isLoadingUsers = false
            })
    }
    
    @IBAction func signOut() {
        Twitter.sharedInstance().logOut()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInViewController: UIViewController! = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as UIViewController
        self.presentViewController(signInViewController, animated: false, completion: nil)
    }
}
