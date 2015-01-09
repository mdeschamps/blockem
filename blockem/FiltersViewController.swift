//
//  FiltersViewController.swift
//  blockem
//
//  Created by Manuel Deschamps on 1/7/15.
//  Copyright (c) 2015 Manuel Deschamps. All rights reserved.
//

import UIKit
import TwitterKit

class FiltersViewController: UIViewController {

    var user: TWTRExtendedUser!
    var friends: [TWTRExtendedUser]!
    var friendsIndex: [String:TWTRExtendedUser]!
    var followers: [TWTRExtendedUser]!
    var followersIndex: [String:TWTRExtendedUser]!
    
    var filteringBots = false
    var maxBlocks: Int? = 100
    
    @IBOutlet weak var profileImageToggle: UISwitch!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var followersSlider: UISlider!
    @IBOutlet weak var friendsCount: UILabel!
    @IBOutlet weak var friendsSlider: UISlider!
    @IBOutlet weak var tweetsCount: UILabel!
    @IBOutlet weak var tweetsSlider: UISlider!
    
    var viewTitle: String = "" {
        didSet {
            self.navigationController?.navigationBar.topItem?.title = viewTitle
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.indexUsers()
        self.updateUIBlockedFollowers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func profileImageToggleChanged(sender: AnyObject) {
        self.updateUIBlockedFollowers()
    }
    
    @IBAction func followersCountChanged(sender: AnyObject) {
        self.followersCount.text = String(format: "%i", Int(followersSlider.value))
        self.updateUIBlockedFollowers()
    }
    
    @IBAction func friendsCountChanged(sender: AnyObject) {
        self.friendsCount.text = String(format: "%i", Int(friendsSlider.value))
        self.updateUIBlockedFollowers()
    }
    
    @IBAction func tweetsCountChanged(sender: AnyObject) {
        self.tweetsCount.text = String(format: "%i", Int(tweetsSlider.value))
        self.updateUIBlockedFollowers()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let botsView = segue.destinationViewController as? BotsViewController {
            botsView.user = self.user
            
            var bots = self.filterBlockedFollowers()
            if maxBlocks != nil {
                botsView.users = Array(bots[0..<min(maxBlocks!, bots.count-1)])
            } else {
                botsView.users = bots
            }
           
        }
    }
    
    private func indexUsers(){
        followersIndex = [String:TWTRExtendedUser]()
        for follower in followers {
            followersIndex[follower.userID] = follower
        }
        
        friendsIndex = [String:TWTRExtendedUser]()
        for friend in friends {
            friendsIndex[friend.userID] = friend
        }
    }
    
    private func updateUIBlockedFollowers(){
        if self.filteringBots {
            return
        }
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let bots = self.filterBlockedFollowers()
            
            dispatch_async(dispatch_get_main_queue()) {
                self.viewTitle = String(format: "Bots: %i", bots.count)
            }
        }
    }
    
    private func filterBlockedFollowers() -> [TWTRExtendedUser] {
        var filteredFollowers = [] + followers
        var bots: [TWTRExtendedUser] = []
        
        self.filteringBots = true
        
        // filter the people you follow
        filteredFollowers = filteredFollowers.filter(){ follower in
            follower.reasons.removeAll(keepCapacity: false)
            return self.friendsIndex[follower.userID] == nil
        }
    
        // block users who dont have a profile image
        if self.profileImageToggle.on {
            var noProfileImages: [TWTRExtendedUser] = filteredFollowers.filter(){ follower in
                var hasImage = follower.profileImageURL.lowercaseString.rangeOfString("default_profile_images") != nil
                if hasImage {
                    follower.reasons.append("No profile image")
                }
                return hasImage
            }
            bots += noProfileImages
        }
        
        var expectedFollowersCount = Int(self.followersSlider.value)
        bots += filteredFollowers.filter(){ follower in
            var fewFollowers = follower.followersCount < expectedFollowersCount
            if fewFollowers {
                follower.reasons.append(String(format: "Followers: %i", follower.followersCount))
            }
            return fewFollowers
        }
        
        var expectedFriendsCount = Int(self.friendsSlider.value)
        bots += filteredFollowers.filter(){ follower in
            var fewFriends = follower.friendsCount < expectedFriendsCount
            if fewFriends {
                follower.reasons.append(String(format: "Friends: %i", follower.friendsCount))
            }
            return fewFriends
        }
        
        var expectedTweetCount = Int(self.tweetsSlider.value)
        bots += filteredFollowers.filter(){ follower in
            var fewTweets = follower.statusesCount < expectedTweetCount
            if fewTweets {
                follower.reasons.append(String(format: "Tweets: %i", follower.statusesCount))
            }
            return fewTweets
        }

        // remove duplicates
        bots = uniq(bots)
        self.filteringBots = false
        
        return bots
    }
    
    private func uniq<S : SequenceType, T : Hashable where S.Generator.Element == T>(source: S) -> [T] {
        var buffer = Array<T>()
        var addedDict = [T: Bool]()
        for elem in source {
            if addedDict[elem] == nil {
                addedDict[elem] = true
                buffer.append(elem)
            }
        }
        return buffer
    }

}
