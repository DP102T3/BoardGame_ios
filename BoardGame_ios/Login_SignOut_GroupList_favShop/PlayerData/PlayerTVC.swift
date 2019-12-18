
import UIKit

class PlayerTVC: UITableViewController {
    @IBOutlet weak var ivPlayer: UIImageView!
    @IBOutlet weak var lbPlayer_nkname: UILabel!
    @IBOutlet weak var lbPlayer_gender: UILabel!
    @IBOutlet weak var lbPlayer_bday: UILabel!
    @IBOutlet weak var lbPlayer_area: UILabel!
    @IBOutlet weak var lbPlayer_star: UILabel!
    @IBOutlet weak var lbFav_bg: UILabel!
    @IBOutlet weak var lbAdept_bg: UILabel!
    @IBOutlet weak var tvPerson: UITextView!
    
    let url_server = URL(string: common_url + "FavServlet")
    static var playerData: PlayerData?
    var player_id = loadUserDefaults("player_id")

    
    override func viewWillAppear(_ animated: Bool) {
        showPlayerData()
        showImage()
    }

    //取得個人資訊
    func showPlayerData() {
        var requestParam = [String: String]()
        requestParam["action"] = "getPersonalData"
        requestParam["player_id"] = player_id
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("playerInput: \(String(data: data!, encoding: .utf8)!)")
                    if let result = try? JSONDecoder().decode(PlayerData.self, from: data!){
                        PlayerTVC.self.playerData = result
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
        requestParam["action"] = "getPlayerImage"
        requestParam["player_id"] = player_id
        //設定個人頭貼尺寸為螢幕的一半大小
        requestParam["playerImageSize"] = view.frame.width/2
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
                DispatchQueue.main.async { self.ivPlayer.image = image }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    //將servlet傳回的值放入lable顯示
    func textLabel(){
        lbPlayer_nkname.text = PlayerTVC.playerData?.player_nkname
        lbPlayer_bday.text = PlayerTVC.playerData?.player_bday
        lbPlayer_area.text = PlayerTVC.playerData?.player_area
        lbPlayer_star.text = PlayerTVC.playerData?.player_star
        lbFav_bg.text = PlayerTVC.playerData?.adept_bg
        lbAdept_bg.text = PlayerTVC.playerData?.adept_bg
        tvPerson.text = PlayerTVC.playerData?.player_intro
        
        //判斷為男性還是女性
        let gender_int = PlayerTVC.playerData?.player_gender
        var gender: String
        if gender_int == 0 {
            gender = "男性"
        }else{
            gender = "女性"
        }
        lbPlayer_gender.text = gender
    }
}
