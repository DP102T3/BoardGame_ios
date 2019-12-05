//
//  favShopVC.swift
//  BoardGame_ios
//
//  Created by 黃國展 on 2019/12/1.
//  Copyright © 2019 黃國展. All rights reserved.
//

import UIKit

class FavShopVC_: UIViewController {
    var favShopDataList = [ShopData]()

    @IBAction func SegmentedAction(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        if selectedIndex == 0 {
            favShopDataList.removeAll()
            
            let resultvc = storyboard?.instantiateViewController(withIdentifier: "PersonSB")
            present(resultvc! , animated: true)
        }else if selectedIndex == 1{
            let resultvc = storyboard?.instantiateViewController(withIdentifier: "GroupSB")
            present(resultvc! , animated: true)
        }else{
            let resultvc = storyboard?.instantiateViewController(withIdentifier: "FavShopSB")
            present(resultvc! , animated: true)
        }
    }
}

