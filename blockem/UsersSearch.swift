//
//  UserSearch.swift
//  blockem
//
//  Created by Manuel Deschamps on 1/6/15.
//  Copyright (c) 2015 Manuel Deschamps. All rights reserved.
//

import TwitterKit

enum UsersResult {
    case Users([TWTRExtendedUser])
    case Error(NSError)
}

private let fetchBatchSize = 200
private let maxUsers: Int? = 2000

private let TwitterAPIFriendsURL = "https://api.twitter.com/1.1/friends/list.json?skip_status=true&include_user_entities=false"
private let TwitterAPIFollowersURL = "https://api.twitter.com/1.1/followers/list.json?skip_status=true&include_user_entities=false"
private let TwitterAPIVerifyCredentialsURL = "https://api.twitter.com/1.1/account/verify_credentials.json"

extension TWTRAPIClient {

    func verifyCredentials(completion: TWTRUser -> ()){
        var maybeError: NSError?
        var request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: TwitterAPIVerifyCredentialsURL, parameters: Dictionary<String, String>(), error: &maybeError)
        
        if let error = maybeError {
            completion(TWTRUser())
            return
        }
        
        // Perform the Twitter API request.
        Twitter.sharedInstance().APIClient.sendTwitterRequest(request, completion: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if error != nil {
                completion(TWTRUser())
                return
            }
            let jsonDictionary = JSONFromData(data)
            completion(TWTRExtendedUser(JSONDictionary: jsonDictionary))
        })
    }
    
    func listFriends(progress: (Int -> ())? = nil, completion: UsersResult -> ()) {
        //completion(.Users([]))
        fetchUsers(TwitterAPIFriendsURL, progress: progress, completion)
    }

    func listFollowers(progress: (Int -> ())? = nil, completion: UsersResult -> ()) {
        fetchUsers(TwitterAPIFollowersURL, progress: progress, completion)
    }
}

private func fetchUsers(APIURL: String, progress: (Int -> ())? = nil, completion: UsersResult -> (), cursor: String = "-1", var users: [TWTRExtendedUser] = []) {
    // Login as a guest on Twitter to search Tweets.
    let APIClient = Twitter.sharedInstance().APIClient
    
    // Setup a Dictionary to store the parameters of the request.
    var parameters = Dictionary<String, String>()
    parameters["cursor"] = cursor
    parameters["count"] = String(fetchBatchSize)
    
    // Prepare the Twitter API request.
    var maybeError: NSError?
    var request = APIClient.URLRequestWithMethod("GET", URL: APIURL, parameters: parameters, error: &maybeError)
    
    if let error = maybeError {
        completion(.Error(error))
        return
    }
    
    // Perform the Twitter API request.
    APIClient.sendTwitterRequest(request, completion: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
        if error != nil {
            completion(.Error(error))
            return
        }
        
        let jsonDictionary = JSONFromData(data)
        if jsonDictionary?["error"] != nil {
            completion(.Error(jsonDictionary!["error"] as NSError))
        }
        
        users += usersFromJSONData(jsonDictionary!)
        
        let nextCursor: String? = jsonDictionary!["next_cursor_str"] as? String
        if ((maxUsers != nil && users.count >= maxUsers!) || nextCursor == nil || nextCursor == "0") {
            return completion(.Users(users))
        }
        
        progress?(users.count)

        // keep loading
        fetchUsers(APIURL, progress: progress, completion, cursor: nextCursor!, users: users)
    })
}

private func JSONFromData(jsonData: NSData) -> [String:AnyObject]? {
    // Parse the JSON response.
    var maybeJSONError: NSError?
    let jsonData: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions(0), error: &maybeJSONError)
    
    // Check for parsing errors.
    if let JSONError = maybeJSONError {
        return ["error": JSONError]
    } else {
        // Make the JSON data a dictionary.
        return jsonData as? [String:AnyObject]
    }
}

private func usersFromJSONData(jsonDictionary: [String:AnyObject]) -> [TWTRExtendedUser] {
    let usersJson = jsonDictionary["users"] as NSArray
    return TWTRUser.usersWithJSONArray(usersJson) as [TWTRExtendedUser]
}