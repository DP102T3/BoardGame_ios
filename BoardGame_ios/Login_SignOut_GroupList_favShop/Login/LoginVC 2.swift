import UIKit

class LoginVC: UIViewController {
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var lbResult: UILabel!
    
    var result: String?
    var userName: String?
    var player_id: String?
    let url_server = URL(string: "http://127.0.0.1:8080/BoardGame_Web/LoginServlet")
    
//    override func loadView() {
//        player_id = loadUserDefaults("player_id")
//        if player_id != nil {
//            if let controllers = self.navigationController?.viewControllers {
//                for vc in controllers {
//                    if vc is FavShopVC_ {
//                        self.navigationController?.popToViewController(vc, animated: false)
//                    }
//                }
//            }
//        }else{
//            if let controllers = self.navigationController?.viewControllers {
//                for vc in controllers {
//                    if vc is LoginVC {
//                        self.navigationController?.popToViewController(vc, animated: false)
//                    }
//                }
//            }
//        }
//    }
    
    @IBAction func clickLogin(_ sender: UIButton) {
        userName = tfUserName.text == nil ? "" : tfUserName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = tfPassword.text == nil ? "" : tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if userName!.isEmpty || password!.isEmpty {
            lbResult?.text = "請輸入帳號密碼"
            return
        }
        
        var requestParam = [String: String]()
        requestParam["type"] = "player"
        requestParam["account"] = userName
        requestParam["password"] = password
        executeTask(url_server!, requestParam)
    }
    
    func executeTask(_ url_server: URL, _ requestParam: [String: String]) {
        print("output: \(requestParam)")
        
        let jsonData = try! JSONEncoder().encode(requestParam)
        var request = URLRequest(url: url_server)
        request.httpMethod = "POST"
        // 不使用cache
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        // 請求參數為JSON data，無需再轉成JSON字串
        request.httpBody = jsonData
        let session = URLSession.shared
        // 建立連線並發出請求，取得結果後會呼叫closure執行後續處理
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                if data != nil {
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    DispatchQueue.main.async {
                        self.result = String(data: data!, encoding: .utf8) ?? "error"
                        //呼叫func next 判斷server端回傳帳密結果
                        self.next(self.result ?? "")
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        task.resume()
    }
    
    func next(_ result: String){
        if result == "correct"{
            tfUserName.text = ""
            tfPassword.text = ""
            lbResult.text = ""
            saveUserDefaults("player_id",userName!)
            //TODO 連結到正確畫面
            let resultvc = storyboard?.instantiateViewController(withIdentifier: "tabSB")
            resultvc?.modalPresentationStyle = .fullScreen
            present(resultvc! , animated: false)
        }else{
            lbResult.text = "帳號密碼錯誤"
        }
    }
    
}

