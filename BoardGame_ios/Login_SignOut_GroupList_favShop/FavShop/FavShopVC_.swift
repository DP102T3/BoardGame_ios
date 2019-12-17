//
//  favShopVC.swift
//  BoardGame_ios
//
//  Created by 黃國展 on 2019/12/1.
//  Copyright © 2019 黃國展. All rights reserved.
//

import UIKit

class FavShopVC_: UIViewController {
    @IBOutlet weak var personalCV: UIView!
    @IBOutlet weak var groupCV: UIView!
    @IBOutlet weak var favShopCV: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        personalCV.isHidden = false
        groupCV.isHidden = true
        favShopCV.isHidden = true
    }
    
    @IBAction func SegmentedAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            personalCV.isHidden = false
            groupCV.isHidden = true
            favShopCV.isHidden = true
        }else if sender.selectedSegmentIndex == 1 {
            personalCV.isHidden = true
            groupCV.isHidden = false
            favShopCV.isHidden = true
        }else {
            personalCV.isHidden = true
            groupCV.isHidden = true
            favShopCV.isHidden = false
        }
    }
}

