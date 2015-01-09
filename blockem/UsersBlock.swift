//
//  UsersBlock.swift
//  blockem
//
//  Created by Manuel Deschamps on 1/6/15.
//  Copyright (c) 2015 Manuel Deschamps. All rights reserved.
//

import TwitterKit


private let TwitterAPIBlockURL = "https://api.twitter.com/1.1/blocks/create.json"
private let TwitterAPIUnblockURL = "https://api.twitter.com/1.1/blocks/destroy.json"

extension TWTRAPIClient {
    
    func blockUsers(userIds: [String], progress: (()->())?, completion: () -> ()) {
        asyncBlockUsers(userIds, progress, completion)
    }
    
    func blockUser(userId: String, completion: () -> ()) {
        asyncBlockUsers([userId], nil, completion)
    }
}

private func asyncBlockUsers(var userIds: [String], progress: (()->())? = nil, completion: () -> ()) {
    if userIds.isEmpty {
        return completion()
    }
    
    var firstUser = userIds.removeAtIndex(0)
    blockUser(firstUser) {
        progress?()
        asyncBlockUsers(userIds, progress, completion)
    }
}

private func blockUser(userId: String, completion: () -> ()) {
    let APIClient = Twitter.sharedInstance().APIClient
    
    // Setup a Dictionary to store the parameters of the request.
    var parameters = Dictionary<String, String>()
    parameters["user_id"] = userId
    parameters["skip_status"] = "true"
    
    // Prepare the Twitter API request.
    var maybeError: NSError?
    var request = APIClient.URLRequestWithMethod("POST", URL: TwitterAPIBlockURL, parameters: parameters, error: &maybeError)
    
    if let error = maybeError {
        completion()
        return
    }
    
    // Perform the Twitter API request.
    APIClient.sendTwitterRequest(request, completion: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
        if error == nil {
            NSLog("User blocked: " + userId)
        }
        
        var maybeError: NSError?
        var request = APIClient.URLRequestWithMethod("POST", URL: TwitterAPIUnblockURL, parameters: parameters, error: &maybeError)

        APIClient.sendTwitterRequest(request, completion: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if error == nil {
                NSLog("User unblocked: " + userId)
            }
            completion()
        })
    })
}