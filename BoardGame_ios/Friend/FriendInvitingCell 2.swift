//
//  FriendInvitedCell.swift
//  BoardGame_ios
//
//  Created by 洪瑞奇 on 2019/12/9.
//  Copyright © 2019 黃國展. All rights reserved.
//

import UIKit

class FriendInvitingCell: UITableViewCell {
    
    var delegate: FriendInvitingDelegate?
    
    @IBOutlet weak var ivFriendInviting: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBAction func btnDeleteOnClick(_ sender: UIButton) {
        delegate?.btnDeleteOnClick(sender.tag)
    }
}
