//
//  UserSearch.swift
//  blockem
//
//  Created by Manuel Deschamps on 1/6/15.
//  Copyright (c) 2015 Manuel Deschamps. All rights reserved.
//

import TwitterKit

enum PoemTweetsResult {
    case Tweets([TWTRTweet])
    case Error(NSError)
}

private let TwitterAPISearchURL = "https://api.twitter.com/1.1/search/tweets.json"
private let PoemSearchQuery = "#cannonballapp AND pic.twitter.com AND (#adventure OR #romance OR #nature OR #mystery)"

extension TWTRAPIClient {

    // Search for poems on Twitter.
    func searchPoemTweets(completion: PoemTweetsResult -> ()) {
        // Login as a guest on Twitter to search Tweets.
        Twitter.sharedInstance().logInGuestWithCompletion { (session: TWTRGuestSession!, error: NSError!) -> Void in

            // Setup a Dictionary to store the parameters of the request.
            var parameters = Dictionary<String, String>()
            parameters["q"] = PoemSearchQuery
            parameters["count"] = "50"

            // Prepare the Twitter API request.
            var maybeError: NSError?
            var request = self.URLRequestWithMethod("GET", URL: TwitterAPISearchURL, parameters: parameters, error: &maybeError)

            if let error = maybeError {
                completion(.Error(error))
                return
            }

            // Perform the Twitter API request.
            self.sendTwitterRequest(request, completion: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                if error != nil {
                    completion(.Error(error))
                    return
                }

                let poemSearchResult = tweetsFromJSONData(data)

                completion(poemSearchResult)
            })
        }
    }

}

private func tweetsFromJSONData(jsonData: NSData) -> PoemTweetsResult {
    // Parse the JSON response.
    var maybeJSONError: NSError?
    let jsonData: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions(0), error: &maybeJSONError)

    // Check for parsing errors.
    if let JSONError = maybeJSONError {
        return PoemTweetsResult.Error(JSONError)
    } else {
        // Make the JSON data a dictionary.
        let jsonDictionary = jsonData as [String:AnyObject]

        // Extract the Tweets and create Tweet objects from the JSON data.
        let jsonTweets = jsonDictionary["statuses"] as NSArray
        let tweets = TWTRTweet.tweetsWithJSONArray(jsonTweets) as [TWTRTweet]

        return .Tweets(tweets)
    }
}