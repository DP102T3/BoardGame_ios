//
//  ShopListTableVC.swift
//  BoardGame_ios
//
//  Created by 洪瑞奇 on 2019/12/16.
//  Copyright © 2019 黃國展. All rights reserved.
//

import UIKit

class ShopListTableVC: UITableViewController {
    
    @IBOutlet var shopTableView: UITableView!
    
        var shopList = [Shop]()
        let url_server = URL(string: urlForFriendAndShop + "GetShops")
        
        override func viewDidLoad() {
            super.viewDidLoad()
            tableViewAddRefreshControl()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            showAllShops()
        }
        
        /** tableView加上下拉更新功能 */
        func tableViewAddRefreshControl() {
            let refreshControl = UIRefreshControl()
            refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            refreshControl.addTarget(self, action: #selector(showAllShops), for: .valueChanged)
            self.tableView.refreshControl = refreshControl
        }
        
        @objc func showAllShops() {
            var requestParam = [String: String]()
            requestParam["action"] = "getAllShop"
            executeTask(url_server!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        // 將輸入資料列印出來除錯用
                        print("shopInput: \(String(data: data!, encoding: .utf8)!)")
                        
//                        do {
//                            try JSONDecoder().decode([Shop].self, from: data!)
//                        } catch {
//                            print(error)
//                        }
                        
                        
                        if let result = try? JSONDecoder().decode([Shop].self, from: data!) {
                            self.shopList = result
                            DispatchQueue.main.async {
                                if let control = self.shopTableView.refreshControl {
                                    if control.isRefreshing {
                                        // 停止下拉更新動作
                                        control.endRefreshing()
                                    }
                                }
                                /* 抓到資料後重刷table view */
                                self.shopTableView.reloadData()
                            }
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return shopList.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cellId = "shopCell"

            let shopCell = tableView.dequeueReusableCell(withIdentifier: cellId,for: indexPath) as! ShopCell
            
            let shop: Shop = shopList[indexPath.row]
            
            //尚未取得圖片，另外開啟task請求
            var requestParam = [String: Any]()
            requestParam["action"] = "getShopImage"
            requestParam["shopId"] = shop.shopId
            // 圖片寬度為tableViewCell的1/4，ImageView的寬度也建議在storyboard加上比例設定的constraint
            requestParam["imageSize"] = shopCell.frame.width / 4
            executeTask(url_server!, requestParam) { (data, response, error) in
                
                var image: UIImage?
                
                if error == nil {
                    print(requestParam)
                    if let data = data {
                        if let base64String = String(data: data, encoding: .utf8) {
                            if let decodedData = NSData(base64Encoded: base64String, options: []){
                                let decodedimage = UIImage(data: decodedData as Data)
                                image = decodedimage
                            }
                        }
                    }
                    if image == nil {
                        image = UIImage(named: "noImage.jpg")
                    }
                    DispatchQueue.main.async { shopCell.ivShop.image = image }
                } else {
                    print(error!.localizedDescription)
                }
            }
            
            shopCell.labelShop.text = shop.shopName
            shopCell.labelAddress.text = shop.shopAddress
            let score = shop.rateTotal / Double(shop.rateCount)
            shopCell.labelRate.text = String(format: "%.1f", score)
            
            shopCell.tag = indexPath.row
            
            return shopCell
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let cell = sender as! ShopCell
            let shop = shopList[cell.tag]
            let detailVC = segue.destination as! ShopDetailViewController
            detailVC.shop = shop
        }
    }
