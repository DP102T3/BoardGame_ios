//
//  MsgReceivedTableViewCell.swift
//  ChatTest_01
//
//  Created by Ryan Tsai on 2019/11/21.
//  Copyright © 2019 Ryan Tsai. All rights reserved.
//

import UIKit

class MsgReceivedTableViewCell: UITableViewCell {
    static let cellId = "msgReceivedCell"
    @IBOutlet weak var imgPortrait: UIImageView!
    @IBOutlet weak var tvReceived: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
