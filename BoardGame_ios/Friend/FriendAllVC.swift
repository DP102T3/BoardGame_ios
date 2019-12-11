//
//  FriendAllVC.swift
//  BoardGame_ios
//
//  Created by 洪瑞奇 on 2019/12/4.
//  Copyright © 2019 黃國展. All rights reserved.
//

import UIKit

class FriendAllVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var friendList: Array<[String:Any]> = []
    @IBOutlet weak var ivNewFriend: UIImageView!
    
    @IBOutlet weak var tableViewAll: UITableView!
    @IBOutlet weak var labelNewFriend: UILabel!
    @IBOutlet weak var labelMoodNewFriend: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchFriendList()
        
        tableViewAll.delegate = self
        tableViewAll.dataSource = self
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func fetchFriendList() {
        // 利用URLSession與server溝通
                   
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
                    
        let url = URL(string: "http://localhost:8080/Advertisement_Server/GetFriendList")
        var request : URLRequest = URLRequest(url: url!)

        // 利用POST方法傳給server
        request.httpMethod = "POST"

        let json: [String: Any] = [
            "player1Id": "myself"
        ]
                    
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
                    
        // 放入body
        request.httpBody = jsonData

        // 把request利用session.dataTask傳給目標server
        let dataTask = session.dataTask(with: request) { data,response,error in
            // 如果沒有response則show error
            guard let httpResponse = response as? HTTPURLResponse
           
            else {
              print("error: not a valid http response")
              return
            }
            
            switch (httpResponse.statusCode) {
               case 200: //success response.
                 if let data = data {
                     if let jsonString = String(data: data, encoding: .utf8) {
                         // jsonString為從server處得到的回應，轉成字串後可以印出查看
                         print(jsonString)
                     }
                     
                     //從json轉成資料格式，以利程式使用
                     if let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String:AnyObject] {
                         print(json)
                         //分別印出所有欄位
                        self.friendList = json["result"] as! Array<[String:Any]>
                        print(self.friendList)
                        
                        let newFriend = self.friendList.last
                        
                        DispatchQueue.main.async {
                            self.labelNewFriend.text = newFriend?["player2Name"] as? String
                            self.labelMoodNewFriend.text = newFriend?["player2Mood"] as? String
                            
                            if let base64String = newFriend?["player2Pic"] {
                                if let decodedData = NSData(base64Encoded: base64String as! String, options: []) {
                                    let decodedimage = UIImage(data: decodedData as Data)
                                    self.ivNewFriend.image = decodedimage
                                }
                            }
                            
                            self.tableViewAll.reloadData()
                        }
//                         print(json["player2Id"] ?? "Empty player2Id")
//                         print(json["player2Name"] ?? "Empty player2Name")
                     }

                 }
                 
                 break
               case 400:
                  break
               default:
                  break
            }
        }
        
        dataTask.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        let imageView = cell.viewWithTag(1) as! UIImageView
        let labelName = cell.viewWithTag(2) as! UILabel
        let labelMood = cell.viewWithTag(3) as! UILabel
        let friend = friendList[indexPath.row]

        labelName.text = friend["player2Name"] as? String
        labelMood.text = friend["player2Mood"] as? String

        if let base64String = friend["player2Pic"] {
            if let decodedData = NSData(base64Encoded: base64String as! String, options: []) {
                let decodedimage = UIImage(data: decodedData as Data)
                imageView.image = decodedimage
            }
        }
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
