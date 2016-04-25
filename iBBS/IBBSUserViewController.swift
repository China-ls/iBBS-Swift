//
//  IBBSUserViewController.swift
//  iBBS
//
//  Created by Augus on 4/18/16.
//  Copyright © 2016 iAugus. All rights reserved.
//

import UIKit

class IBBSUserViewController: UIViewController {
    
    var userId: Int!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userImageView: IBBSAvatarImageView! {
        didSet {
            userImageView.layer.cornerRadius = userImageView.frame.width / 2
            userImageView.userInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var usernameLabel: UILabel! {
        didSet {
            usernameLabel.text = String(userId)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem?.target = self
        navigationItem.leftBarButtonItem?.action = #selector(dismissViewController)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let identifier = "GoToChatViewController"
        
        guard segue.identifier == identifier else { return }
        
        guard let vc = segue.destinationViewController as? IBBSChatViewController else { return }
        
        vc.receiver = userId
    }

}
