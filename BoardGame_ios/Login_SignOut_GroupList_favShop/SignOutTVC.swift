//
//  SingOutTVC.swift
//  BoardGame_ios
//
//  Created by 黃國展 on 2019/11/27.
//  Copyright © 2019 黃國展. All rights reserved.
//

import UIKit

class SignOutTVC: UITableViewController {
    override func viewWillDisappear(_ animated: Bool){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "player_id")
    }
}


