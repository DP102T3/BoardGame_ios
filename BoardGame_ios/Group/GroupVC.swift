

import UIKit

class GroupVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var groupColletctionView: UICollectionView!
    var fullScreenSize :CGSize!
    var groupListDatas = [GroupListData]()
    let url_server = URL(string: common_url + "FavServlet")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //取得螢幕的尺寸
        fullScreenSize = UIScreen.main.bounds.size
        // 設定UICollectionView背景色
        groupColletctionView.backgroundColor = UIColor.white
        // 取得UICollectionView排版物件
        let layout = groupColletctionView.collectionViewLayout as! UICollectionViewFlowLayout
        // 設定內容與邊界的間距
        layout.sectionInset = UIEdgeInsets(top: 25, left: 5, bottom: 25, right: 5);
        // 設定每一列的間距
        layout.minimumLineSpacing = 25
        layout.minimumInteritemSpacing = 10
        // 設定每個項目的尺寸
        layout.itemSize = CGSize(
            width: CGFloat(fullScreenSize.width - 10 - 10)/2,
            height: CGFloat(fullScreenSize.width)-100)
        
        layout.estimatedItemSize = .zero
        
        //  layout.itemSize = CGSize(width: 300, height: 300)
        
        collectionViewAddRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showGroupList()
    }
    
    func collectionViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(showGroupList), for: .valueChanged)
        self.groupColletctionView.refreshControl = refreshControl
    }
    
    //取得所有團資訊
    @objc func showGroupList() {
        var requestParam = [String: String]()
        requestParam["action"] = "getGroupLsit"
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("groupInput: \(String(data: data!, encoding: .utf8)!)")
                    
                    if let result = try? JSONDecoder().decode([GroupListData].self, from: data!) {
                        self.groupListDatas = result
                        DispatchQueue.main.async {
                            if let control = self.groupColletctionView.refreshControl {
                                if control.isRefreshing {
                                    // 停止下拉更新動作
                                    control.endRefreshing()
                                }
                            }
                            /* 抓到資料後重刷ColletctionView */
                            self.groupColletctionView.reloadData()
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupListDatas.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewGroupCell", for: indexPath) as? GroupListCollectionViewCell
            cell?.layer.borderWidth = 1
            cell?.layer.cornerRadius = 5
            
            return cell!

        } else {
            let groupList = groupListDatas[indexPath.item-1]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupListCell", for: indexPath) as? GroupListCollectionViewCell
            cell?.layer.borderWidth = 1
            cell?.layer.cornerRadius = 5
            
            //尚未取得圖片，另外開啟task請求
            var requestParam = [String: Any]()
            requestParam["action"] = "getGroupImage"
            requestParam["group_no"] = groupList.group_no
            requestParam["imageSize"] = cell?.frame.width
            var image: UIImage?
            executeTask(url_server!, requestParam) { (data, response, error) in
                print(requestParam)
                if error == nil {
                    print(data!)
                    if data != nil {
                        image = UIImage(data: data!)
                    }
                    if image == nil {
                        image = UIImage(named: "noImage.jpg")
                    }
                    DispatchQueue.main.async { cell?.ivGroup.image = image }
                } else {
                    print(error!.localizedDescription)
                }
            }
            
            cell?.lbGroupName.text = "團名：\(groupList.group_name)"
            cell?.lbGroupSetTime.text = groupList.setup_time
            cell?.lbArea.text = groupList.area_lv2
            
            return cell!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /* identifier必須設定與Indentity inspector的Storyboard ID相同 */
        let groupDetailTVC = self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailSB") as! GroupDetailTVC
        let groupListData = groupListDatas[indexPath.item-1]
        groupDetailTVC.groupListData = groupListData
        self.navigationController?.pushViewController(groupDetailTVC, animated: false)
    }
}
