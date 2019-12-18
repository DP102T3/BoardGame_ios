//
//  GroupDetailTVC.swift
//  BoardGame_ios
//
//  Created by 黃國展 on 2019/12/16.
//  Copyright © 2019 黃國展. All rights reserved.
//

import UIKit

class GroupDetailTVC: UITableViewController {
    @IBOutlet weak var ivGroupDetail: UIImageView!
    @IBOutlet weak var lbShopName: UILabel!
    @IBOutlet weak var lbArea: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbGroup_np: UILabel!
    @IBOutlet weak var lbGameType: UILabel!
    @IBOutlet weak var lbGame: UILabel!
    @IBOutlet weak var lbBudget: UILabel!
    @IBOutlet weak var lbSignupDate: UILabel!
    @IBOutlet weak var lbSignupTime: UILabel!
    @IBOutlet weak var lbOtherInfo: UILabel!
    
    let url_server = URL(string: common_url + "FavServlet")
    var group_no: Int?
    var groupDetailData: GroupDetailData?
    
    override func viewWillAppear(_ animated: Bool) {
        showGroupDetailData()
        showImage()
    }
    
    //取得個人資訊
    func showGroupDetailData() {
        var requestParam = [String: String]()
        requestParam["action"] = "getGroupDetailData"
        requestParam["group_no"] = String(group_no!)
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("groupDetailDataInput: \(String(data: data!, encoding: .utf8)!)")
                    if let result = try? JSONDecoder().decode(GroupDetailData.self, from: data!){
                        self.groupDetailData = result
                        DispatchQueue.main.async {
                            self.textLabel()
                            self.tableView.reloadData()
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    //取得個人頭貼
    func showImage(){
        var requestParam = [String: Any]()
        requestParam["action"] = "getGroupImage"
        requestParam["group_no"] = group_no
        //設定圖片尺寸為螢幕的一半大小
        requestParam["imageSize"] = view.frame.width/2
        var image: UIImage?
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                print(requestParam)
                if data != nil {
                    image = UIImage(data: data!)
                }
                if image == nil {
                    image = UIImage(named: "noImage.jpg")
                }
                DispatchQueue.main.async { self.ivGroupDetail.image = image }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    //將servlet傳回的值放入lable顯示
    func textLabel(){
        self.title = groupDetailData?.group_name
        lbShopName.text = groupDetailData?.shop_name
        lbArea.text = "\(groupDetailData?.area_lv2 ?? "")\(groupDetailData?.area_lv3 ?? "")"
        lbDate.text = (groupDetailData?.time_start as NSString?)?.substring(with: NSMakeRange(0,10))
        lbTime.text = "\((groupDetailData?.time_start as NSString?)?.substring(with: NSMakeRange(11,5)) ?? "") ~ \((groupDetailData?.time_end as NSString?)?.substring(with: NSMakeRange(11,5)) ?? "")"
        lbGroup_np.text = "\(groupDetailData?.np_lower.description ?? "") ~ \( groupDetailData?.np_upper.description ?? "") (目前\(groupDetailData?.group_np.description ?? "")人參加)"
        lbGameType.text = groupDetailData?.game_type
        lbGame.text = groupDetailData?.game_name
        lbBudget.text = groupDetailData?.game_budget.description
        lbSignupDate.text = (groupDetailData?.signup_time as NSString?)?.substring(with: NSMakeRange(0,10))
        lbSignupTime.text = (groupDetailData?.signup_time as NSString?)?.substring(with: NSMakeRange(11,5))
        lbOtherInfo.text = groupDetailData?.other_info
    }
}
