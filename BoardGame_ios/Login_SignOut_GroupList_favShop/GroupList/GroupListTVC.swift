//
//  GroupListTVC.swift
//  BoardGame_ios
//
//  Created by 黃國展 on 2019/12/5.
//  Copyright © 2019 黃國展. All rights reserved.
//dd

import UIKit

class GroupListTVC: UITableViewController {
    var favGroupData = [GroupData]()
    let url_server = URL(string: common_url + "FavShopServlet")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewAddRefreshControl()
        showAllFavGroup()
        print("GroupViewDidLoad")
    }
    
    /** tableView加上下拉更新功能 */
    func tableViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(showAllFavGroup), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    @objc func showAllFavGroup() {
        var requestParam = [String: String]()
        requestParam["action"] = "getAllFavGroup"
        requestParam["player_id"] = "chengchi1223"
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    
                    if let result = try? JSONDecoder().decode([GroupData].self, from: data!) {
                        self.favGroupData = result
                        DispatchQueue.main.async {
                            if let control = self.tableView.refreshControl {
                                if control.isRefreshing {
                                    // 停止下拉更新動作
                                    control.endRefreshing()
                                }
                            }
                            /* 抓到資料後重刷table view */
                            self.tableView.reloadData()
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
        print("GroupTableView count")
        return favGroupData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("GroupCellForRowAt")
        let cellId = "favGroup"
        // tableViewCell預設的imageView點擊後會改變尺寸，所以建立UITableViewCell子類別SpotCell
        let favGroupCell = tableView.dequeueReusableCell(withIdentifier: cellId,for: indexPath) as! GroupCell
        
        let group = favGroupData[indexPath.row]
        
        //尚未取得圖片，另外開啟task請求
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["shop_id"] = group.group_no
        // 圖片寬度為tableViewCell的1/4，ImageView的寬度也建議在storyboard加上比例設定的constraint
        requestParam["imageSize"] = favGroupCell.frame.width / 4
        var image: UIImage?
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                }
                if image == nil {
                    image = UIImage(named: "noImage.jpg")
                }
                DispatchQueue.main.async { favGroupCell.ivGroup.image = image }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        favGroupCell.lbGroupName.text = group.group_Name
        
        //判斷店家是否同意丟訂位
        var check: String?
        let checkNumber = group.group_check
        if checkNumber == 0{
            check = "店家未審核"
        }else if checkNumber == 1{
            check = "店家已同意"
        }else {
            check = "店家駁回"
        }
        
        favGroupCell.lbCheck.text = check
        
//
//        let long_time = formateTime(timeStamp: group.long_time)
//        favGroupCell.lbTime.text = long_time.description
        return favGroupCell
    }

    
    func formateTime(timeStamp: CLong)->(NSDate){
        let nowDate = NSDate(timeIntervalSinceNow: 0)
        // 時間戳的值
        let timeStamp:CLong = CLong(nowDate.timeIntervalSince1970)
        print(timeStamp)
        //把時間戳轉換為時間
        let confromTimestampDate = NSDate.init(timeIntervalSince1970: TimeInterval(timeStamp))
        print(confromTimestampDate)
        
        return confromTimestampDate
    }
}
