//
//  TWTRUserTableViewCell.swift
//  blockem
//
//  Created by Manuel Deschamps on 1/7/15.
//  Copyright (c) 2015 Manuel Deschamps. All rights reserved.
//

import UIKit
import TwitterKit

class TWTRUserTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    private var user: TWTRUser = TWTRUser() {
        didSet {
            name?.text = user.name
            screenName?.text = user.formattedScreenName
            // Set image.
            NSURLConnection.sendAsynchronousRequest(
                NSURLRequest(URL: NSURL(string: user.profileImageURL)!),
                queue: NSOperationQueue.mainQueue(),
                completionHandler: {
                    (response: NSURLResponse!, data: NSData!, err: NSError!) -> Void in
                    let image = UIImage(data: data)
                    self.avatar.image = image
                    self.avatar.layer.cornerRadius = 5;
                    self.avatar.clipsToBounds = true;
                }
            )
        }
    }
    
    func configureWithUser(user: TWTRUser) {
        self.user = user
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
