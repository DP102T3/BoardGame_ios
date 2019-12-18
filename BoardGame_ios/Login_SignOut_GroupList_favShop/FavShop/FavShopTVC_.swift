import UIKit

class FavShopTVC_: UITableViewController, FavShopVCCellDelegate {
    
    @IBOutlet var favTableView: UITableView!
    var shop: Shop?
    var indexPath: IndexPath?
    var favShopData = [Shop]()
    let url_server = URL(string: common_url + "FavServlet")
    var player_id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewAddRefreshControl()
        player_id = loadUserDefaults("player_id")
        print("FavShopTVC_\(String(describing: player_id))")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showAllFavShops()
    }
    
    /** tableView加上下拉更新功能 */
    func tableViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(showAllFavShops), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    @objc func showAllFavShops() {
        var requestParam = [String: String]()
        requestParam["action"] = "getAllFavShop"
        requestParam["player_id"] = player_id
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("shopInput: \(String(data: data!, encoding: .utf8)!)")
                    
                    if let result = try? JSONDecoder().decode([Shop].self, from: data!) {
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("favShopData.count:\(favShopData.count)")
        // #warning Incomplete implementation, return the number of rows
        return favShopData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("FavShopCellForRowAt")
        let cellId = "favShop"
        // tableViewCell預設的imageView點擊後會改變尺寸，所以建立UITableViewCell子類別SpotCell
        let favShopCell = tableView.dequeueReusableCell(withIdentifier: cellId,for: indexPath) as! FavShopCell
        
        shop = favShopData[indexPath.row]
        favShopCell.delegate = self
        
        //尚未取得圖片，另外開啟task請求
        var requestParam = [String: Any]()
        requestParam["action"] = "getShopImage"
        requestParam["shop_id"] = shop?.shopId
        // 圖片寬度為tableViewCell的1/4，ImageView的寬度也建議在storyboard加上比例設定的constraint
        requestParam["imageSize"] = favShopCell.frame.width / 4
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
                DispatchQueue.main.async { favShopCell.ivFavShop.image = image }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        favShopCell.lbShopName.text = shop?.shopName
        favShopCell.lbAddress.text = shop?.shopAddress
        let score = String(shop!.rateTotal / Double(shop!.rateCount))
        favShopCell.lbRate.text = String(format: "%.1f", score)
        return favShopCell
    }
    
    func favShopVCCellOnClick(_ sender: FavShopCell) {
        indexPath = self.tableView.indexPath(for: sender)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shopListVC = self.storyboard?.instantiateViewController(withIdentifier: "ShopListSB") as! ShopDetailViewController
        self.navigationController?.pushViewController(shopListVC, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let shop = favShopData[indexPath!.row]
        let mapVC = segue.destination as! MapVC
        mapVC.favshop = shop
    }
}
