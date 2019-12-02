//
//  FavShopCell.swift
//  BoardGame_ios
//
//  Created by 黃國展 on 2019/11/28.
//  Copyright © 2019 黃國展. All rights reserved.
//

import UIKit

class FavShopCell: UITableViewCell {
    @IBOutlet weak var ivFavShop: UIImageView!
    @IBOutlet weak var lbShopName: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbRate: UILabel!
    
    override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
       }

       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)

           // Configure the view for the selected state
       }
}
