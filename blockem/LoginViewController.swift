//
//  LoginViewController.swift
//  blockem
//
//  Created by Manuel Deschamps on 1/6/15.
//  Copyright (c) 2015 Manuel Deschamps. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController {

    @IBOutlet weak var appImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appImage.layer.cornerRadius = 75
        self.appImage.clipsToBounds = true
        self.appImage.layer.borderColor = UIColor.grayColor().CGColor
        self.appImage.layer.borderWidth = 1
          
        let logInButton = TWTRLogInButton(logInCompletion: {
            (session: TWTRSession!, error: NSError!) in
            self.showFriendsViewController()
        })
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showFriendsViewController() {
        self.performSegueWithIdentifier("ShowFriendsSegue", sender: self)
    }
}
