//
//  ScanQRCodeCell.swift
//  BoardGame_ios
//
//  Created by 洪瑞奇 on 2019/12/10.
//  Copyright © 2019 黃國展. All rights reserved.
//

import UIKit

class ScanQRCodeCell: UITableViewCell {
    var delegate: ScanQRCodeDelegate?
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var ivFriend: UIImageView!
    
    @IBOutlet weak var btnInvite: UIButton!
    
    @IBAction func onBtnInviteOnClick(_ sender: UIButton) {
        delegate?.onBtnInviteOnClick(sender.tag)
    }
}
