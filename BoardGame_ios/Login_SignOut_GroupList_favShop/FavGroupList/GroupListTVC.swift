import UIKit

class GroupListTVC: UITableViewController {
    var favGroupData = [GroupData]()
    let url_server = URL(string: common_url + "FavServlet")
    var player_id = loadUserDefaults("player_id")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTableViewAddRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         showAllFavGroup()
    }
    
    /** tableView加上下拉更新功能 */
    func groupTableViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(showAllFavGroup), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    @objc func showAllFavGroup() {
        var requestParam = [String: String]()
        requestParam["action"] = "getAllFavGroup"
        requestParam["player_id"] = player_id
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("groupInput: \(String(data: data!, encoding: .utf8)!)")
                    
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
        return favGroupData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:
        IndexPath) -> UITableViewCell {
        let cellId = "GroupCell"
        let favGroupCell = tableView.dequeueReusableCell(withIdentifier: cellId,for: indexPath) as! GroupCell
        
        let group = favGroupData[indexPath.row]
        
        //尚未取得圖片，另外開啟task請求
        var requestParam = [String: Any]()
        requestParam["action"] = "getGroupImage"
        requestParam["group_no"] = group.group_no
        // 圖片寬度為tableViewCell的1/4，ImageView的寬度也建議在storyboard加上比例設定的constraint
        requestParam["imageSize"] = favGroupCell.frame.width / 4
        var image: UIImage?
        executeTask(url_server!, requestParam) { (data, response, error) in
            print(requestParam)
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
        
        favGroupCell.lbGroupName.text = group.group_name
        
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
        favGroupCell.lbTime.text = group.setup_time
        return favGroupCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groupDetailTVC = self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailSB") as! GroupDetailTVC
        let groupData = favGroupData[indexPath.row]
        groupDetailTVC.group_no = groupData.group_no
        self.navigationController?.pushViewController(groupDetailTVC, animated: false)
    }
}
