//
//  FriendInvitedCell.swift
//  BoardGame_ios
//
//  Created by 洪瑞奇 on 2019/12/9.
//  Copyright © 2019 黃國展. All rights reserved.
//

import UIKit

class FriendInvitedCell: UITableViewCell {
    
    var delegate: FriendInvitedDelegate?
    
    @IBOutlet weak var ivInvited: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var btnDecline: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    
    @IBAction func btnDeclineOnClick(_ sender: UIButton) {
        print("btnDeclineOnClick")
        delegate?.btnDeclineOnClick(sender.tag)
    }
    
    @IBAction func btnAcceptOnClick(_ sender: UIButton) {
        print("btnAcceptOnClick")
        delegate?.btnAcceptOnClick(sender.tag)
    }
}
