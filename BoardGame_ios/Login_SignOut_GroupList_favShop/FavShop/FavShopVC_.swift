//
//  favShopVC.swift
//  BoardGame_ios
//
//  Created by 黃國展 on 2019/12/1.
//  Copyright © 2019 黃國展. All rights reserved.
//

import UIKit

class FavShopVC_: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.children[0].view.isHidden = false
        self.children[1].view.isHidden = true
        self.children[2].view.isHidden = true
    }

    @IBAction func SegmentedAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.children[0].view.isHidden = false
            self.children[1].view.isHidden = true
            self.children[2].view.isHidden = true
        } else if sender.selectedSegmentIndex == 1 {
            self.children[0].view.isHidden = true
            self.children[1].view.isHidden = false
            self.children[2].view.isHidden = true
        } else {
            self.children[0].view.isHidden = true
            self.children[1].view.isHidden = true
            self.children[2].view.isHidden = false
        }
    }
}

