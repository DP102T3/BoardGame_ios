//
//  FriendInvitingVC.swift
//  BoardGame_ios
//
//  Created by 洪瑞奇 on 2019/12/4.
//  Copyright © 2019 黃國展. All rights reserved.
//

import UIKit

class FriendInvitingVC: UIViewController, UITableViewDelegate, UITableViewDataSource,  FriendInvitingDelegate {
    
    @IBOutlet weak var tableViewInviting: UITableView!
    
    var invitingFriendList: Array<[String:Any]> = []
    let user = loadUserDefaults("player_id")

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewInviting.dataSource = self
        tableViewInviting.delegate = self
        
        fetchInvitingFriendList()
        // Do any additional setup after loading the view.
    }
    
    func fetchInvitingFriendList() {
        // 利用URLSession與server溝通
                   
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
                    
        let url = URL(string: "http://127.0.0.1:8080/Advertisement_Server/GetFriendList")
        var request : URLRequest = URLRequest(url: url!)

        // 利用POST方法傳給server
        request.httpMethod = "POST"

        let json: [String: Any] = [
            "player1Id": "\(user)"
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
                        self.invitingFriendList = (json["result"] as! Array<[String:Any]>).filter({ (friend: [String : Any]) -> Bool in
                            
                            return friend["inviteStatus"] as! Int == 1
                        })
                           
                        print(self.invitingFriendList)
                        DispatchQueue.main.async {
                            self.tableViewInviting.reloadData()
                        }
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
    
    
    func btnDeleteOnClick(_ tag: Int) {
        deleteFriend(friend: invitingFriendList[tag])
    }
    
    func deleteFriend(friend: [String: Any]) {
        // 利用URLSession與server溝通
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
                    
        let url = URL(string: "http://127.0.0.1:8080/Advertisement_Server/DeleteFriend")
        var request : URLRequest = URLRequest(url: url!)

        // 利用POST方法傳給server
        request.httpMethod = "POST"

        let json: [String: Any] = [
            "player1Id": "\(user)",
            "player2Id": friend["player2Id"] as! String
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
                self.fetchInvitingFriendList()
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
        return self.invitingFriendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FriendInvitingCell
               
        cell.delegate = self

        cell.btnDelete.tag = indexPath.row

        let friend = invitingFriendList[indexPath.row]

        cell.labelName.text = friend["player2Name"] as? String
       
        if let base64String = friend["player2Pic"] {
           if let decodedData = NSData(base64Encoded: base64String as! String, options: []) {
               let decodedimage = UIImage(data: decodedData as Data)
               cell.ivFriendInviting.image = decodedimage
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
