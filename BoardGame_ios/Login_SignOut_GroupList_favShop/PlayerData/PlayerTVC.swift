
import UIKit

class PlayerTVC: UITableViewController {
    @IBOutlet weak var ivPlayer: UIImageView!
    @IBOutlet weak var lbPageControl: UIPageControl!
    @IBOutlet weak var lbPlayer_nkname: UILabel!
    @IBOutlet weak var lbPlayer_gender: UILabel!
    @IBOutlet weak var lbPlayer_bday: UILabel!
    @IBOutlet weak var lbPlayer_area: UILabel!
    @IBOutlet weak var lbPlayer_star: UILabel!
    @IBOutlet weak var lbFav_bg: UILabel!
    @IBOutlet weak var lbAdept_bg: UILabel!
    @IBOutlet weak var tvPerson: UITextView!
    
    let url_server = URL(string: common_url + "FavServlet")
    var playerData: PlayerData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showPlayerData()
        showImage()
    }
    
    func showPlayerData() {
        var requestParam = [String: String]()
        requestParam["action"] = "getPersonalData"
        requestParam["player_id"] = "chengchi1223"
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("playerInput: \(String(data: data!, encoding: .utf8)!)")
                    if let result = try? JSONDecoder().decode(PlayerData.self, from: data!){
                        self.playerData = result
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
    
    func showImage(){
        var requestParam = [String: Any]()
        requestParam["action"] = "getPlayerImage"
        requestParam["player_id"] = "chengchi1223"
        requestParam["playerImageSize"] = ivPlayer.frame.width
        var image: UIImage?
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                print(requestParam)
                if data != nil {
                    print("ShopImageInput: \(data!)")
                    image = UIImage(data: data!)
                }
                if image == nil {
                    image = UIImage(named: "noImage.jpg")
                }
                DispatchQueue.main.async { self.ivPlayer.image = image }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 9
    }
    
    func textLabel(){
        lbPlayer_nkname.text = playerData?.player_nkname
        lbPlayer_bday.text = playerData?.player_bday
        lbPlayer_area.text = playerData?.player_area
        lbPlayer_star.text = playerData?.player_star
        lbFav_bg.text = playerData?.adept_bg
        lbAdept_bg.text = playerData?.adept_bg
        tvPerson.text = playerData?.player_intro
        
        let gender_int = playerData?.player_gender
        var gender: String
        if gender_int == 0 {
            gender = "男性"
        }else{
            gender = "女性"
        }
        lbPlayer_gender.text = gender
    }
}
