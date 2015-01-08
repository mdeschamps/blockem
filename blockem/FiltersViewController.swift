//
//  FiltersViewController.swift
//  blockem
//
//  Created by Manuel Deschamps on 1/7/15.
//  Copyright (c) 2015 Manuel Deschamps. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {

    @IBOutlet weak var profileImageToggle: UISwitch!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var followersSlider: UISlider!
    @IBOutlet weak var friendsCount: UILabel!
    @IBOutlet weak var friendsSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func followersCountChanged(sender: AnyObject) {
        followersCount.text = String(format: "%i", Int(followersSlider.value))
    }
    
    @IBAction func friendsCountChanged(sender: AnyObject) {
        friendsCount.text = String(format: "%i", Int(friendsSlider.value))
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
