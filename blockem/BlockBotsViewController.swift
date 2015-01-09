//
//  BlockBotsViewController.swift
//  blockem
//
//  Created by Manuel Deschamps on 1/8/15.
//  Copyright (c) 2015 Manuel Deschamps. All rights reserved.
//

import UIKit
import TwitterKit

class BlockBotsViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    var user: TWTRExtendedUser!
    var bots: [TWTRExtendedUser]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.blockThem()
    }
    
    func blockThem() {
        var botsIds: [String] = self.bots.map({ bot in
            return bot.userID
        })
        
        var total = botsIds.count
        var done = 0
        
        Twitter.sharedInstance().APIClient.blockUsers(botsIds, progress: {
            done++
            self.progressLabel.text = String(format:"%i of %i", done, total)
            self.progressBar.setProgress(Float(done) / Float(total), animated: false)
        }){
            let alertController = UIAlertController(title: "Good bye Bots!", message:
                "Congrats, you are Bot free.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "Start over", style: UIAlertActionStyle.Default, handler: { Void in
                self.navigationController?.popToRootViewControllerAnimated(true)
                return
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}
