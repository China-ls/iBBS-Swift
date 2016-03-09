//
//  IBBSTableViewCell.swift
//  iBBS
//
//  Created by Augus on 9/2/15.
//
//  http://iAugus.com
//  https://github.com/iAugux
//
//  Copyright © 2015 iAugus. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class IBBSTableViewCell: UITableViewCell {

    @IBOutlet weak var userProfireImage: IBBSAvatarImageView!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var nodeName: UILabel!
    @IBOutlet weak var postTime: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
//        selectionStyle = UITableViewCellSelectionStyle.None

        // Initialization code
//        backgroundColor = UIColor.clearColor()

        separatorInset = UIEdgeInsetsZero
        layoutMargins  = UIEdgeInsetsZero
        selectionStyle = .None
 
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func loadDataToCell(json: JSON){
        let avatarUrl                        = NSURL(string: json["avatar"].stringValue)
        userProfireImage.kf_setImageWithURL(avatarUrl!, placeholderImage: AVATAR_PLACEHOLDER_IMAGE)
        topicLabel?.text                = json["title"].stringValue
        userName.text                   = json["username"].stringValue
        nodeName.text                   = json["board"].stringValue
        postTime.text                   = json["post_time"].stringValue
    }

}
