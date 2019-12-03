//
//  ChatTableViewCell.swift
//  ChatTest_01
//
//  Created by Ryan Tsai on 2019/11/21.
//  Copyright © 2019 Ryan Tsai. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    static let cellId = "chatCell"
    @IBOutlet weak var chatListImage: UIImageView!
    @IBOutlet weak var chatListName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

