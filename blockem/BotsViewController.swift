//
//  FollowersViewController.swift
//  blockem
//
//  Created by Manuel Deschamps on 1/6/15.
//  Copyright (c) 2015 Manuel Deschamps. All rights reserved.
//

import UIKit
import TwitterKit

class BotsViewController: UsersViewController {
    
    var user: TWTRExtendedUser!
    
    override func viewDidLoad() {
        self.viewLabel = "Bots"
        
        super.viewDidLoad()
        
        // Setup the table view.
        initViewController()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let blockView = segue.destinationViewController as? BlockBotsViewController {
            blockView.user = self.user
            blockView.bots = self.users
        }
    }
}
