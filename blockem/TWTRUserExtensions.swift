//
//  TWTRUserExtensions.swift
//  blockem
//
//  Created by Manuel Deschamps on 1/8/15.
//  Copyright (c) 2015 Manuel Deschamps. All rights reserved.
//

import Foundation
import TwitterKit

extension TWTRUser {
    class func usersWithJSONArray(array: [AnyObject]!) -> [TWTRExtendedUser] {
        var users: [TWTRExtendedUser] = []
        for userObject in array {
            var user = TWTRExtendedUser(JSONDictionary: userObject as [NSObject : AnyObject])
            users.append(user)
        }
        return users
    }
}

class TWTRExtendedUser: TWTRUser {
    var followersCount: Int!
    var friendsCount: Int!
    var statusesCount: Int!
    
    var reasons: [String] = []
    
    override init(JSONDictionary dictionary: [NSObject : AnyObject]!) {
        super.init(JSONDictionary: dictionary)
        
        self.followersCount = dictionary["followers_count"] as Int
        self.friendsCount = dictionary["friends_count"] as Int
        self.statusesCount = dictionary["statuses_count"] as Int
    }
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}