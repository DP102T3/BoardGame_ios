//
//  favShopVC.swift
//  BoardGame_ios
//
//  Created by 黃國展 on 2019/12/1.
//  Copyright © 2019 黃國展. All rights reserved.
//

import UIKit

class FavShopVC: UIViewController, UITableViewDataSource ,UITableViewDelegate{
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var favTableView: UITableView!
    
    
    var favShopData = [ShopData]()
    let url_server = URL(string: common_url + "FavShopServlet")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewAddRefreshControl()
        print("viewDidLoad")
    }
    
    /** tableView加上下拉更新功能 */
    func tableViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(showAllFavShops), for: .valueChanged)
        self.favTableView.refreshControl = refreshControl
    }
    
    //        override func viewWillAppear(_ animated: Bool) {
    //            showAllFavShops()
    //            print("viewWillAppear")
    //        }
    
    @objc func showAllFavShops() {
        var requestParam = [String: String]()
        requestParam["action"] = "getAll"
        requestParam["player_id"] = "chengchi1223"
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    
                    if let result = try? JSONDecoder().decode([ShopData].self, from: data!) {
                        self.favShopData = result
                        DispatchQueue.main.async {
                            if let control = self.favTableView.refreshControl {
                                if control.isRefreshing {
                                    // 停止下拉更新動作
                                    control.endRefreshing()
                                }
                            }
                            /* 抓到資料後重刷table view */
                            self.favTableView.reloadData()
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("tableView count")
        return favShopData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segmentedControl.indexPathForSelectedRow {
        case 0:
            print("關於頁面")
            favShopData.removeAll()
            self.favTableView.reloadData()
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell",for: indexPath) as! FavGroupCell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "favShop",for: indexPath) as! FavShopCell
            favShopData.removeAll()
            showAllFavShops()
        default:
            break
        }
        
        let shop = favShopData[indexPath.row]
        
        //尚未取得圖片，另外開啟task請求
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["shop_id"] = shop.shop_id
        // 圖片寬度為tableViewCell的1/4，ImageView的寬度也建議在storyboard加上比例設定的constraint
        requestParam["imageSize"] = cell.frame.width / 4
        var image: UIImage?
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                }
                if image == nil {
                    image = UIImage(named: "noImage.jpg")
                }
                DispatchQueue.main.async { cell.ivFavShop.image = image }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        
        //        cell.delegate = self
        cell.lbShopName.text = shop.shopName
        cell.lbAddress.text = shop.address
        cell.lbRate.text = String(shop.rate)
        return cell
    }
    
    //    @IBAction func SegmentedChage(_ sender: UISegmentedControl) {
    //        if sender.selectedSegmentIndex == 2{
    //              favShopData.removeAll()
    //              showAllFavShops()
    //        }else{
    //            favShopData.removeAll()
    //            self.favTableView.reloadData()
    //        }
    //    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue" {
            let indexPath = favTableView.indexPathForSelectedRow
            let favShop = favShopData[indexPath!.row]
            let controllor = segue.destination as! MapVC
            controllor.favshop = favShop
        }
    }
}