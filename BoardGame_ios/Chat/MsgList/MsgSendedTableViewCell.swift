//
//  MsgSendedTableViewCell.swift
//  ChatTest_01
//
//  Created by Ryan Tsai on 2019/11/23.
//  Copyright © 2019 Ryan Tsai. All rights reserved.
//

import UIKit

class MsgSendedTableViewCell: UITableViewCell {
    static let cellId = "msgSendedCell"
    @IBOutlet weak var tvSended: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
