//
//  FriendInvitedVC.swift
//  BoardGame_ios
//
//  Created by 洪瑞奇 on 2019/12/4.
//  Copyright © 2019 黃國展. All rights reserved.
//

import UIKit

class FriendInvitedVC: UIViewController, UITableViewDataSource, UITableViewDelegate, FriendInvitedDelegate {

    var invitedFriendList: Array<[String:Any]> = []
    @IBOutlet weak var tableViewInvited: UITableView!
  
    let user = loadUserDefaults("player_id")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableViewInvited.delegate = self
        tableViewInvited.dataSource = self
        
        fetchInvitedFriendList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchInvitedFriendList()
    }
    
    func fetchInvitedFriendList() {
        // 利用URLSession與server溝通
                   
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
                    
        let url = URL(string: "http://127.0.0.1:8080/Advertisement_Server/GetFriendList")
        var request : URLRequest = URLRequest(url: url!)

        // 利用POST方法傳給server
        request.httpMethod = "POST"

        let json: [String: Any] = [
            "action": "invited",
            "playerId": "\(user)"
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
                     
                     //從json轉成資料格式，以利程式使用
                     if let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String:AnyObject] {
                        self.invitedFriendList = (json["result"] as! Array<[String:Any]>).filter({ (friend: [String : Any]) -> Bool in
                            
                            return friend["inviteStatus"] as! Int == 1
                        })
                           
                        DispatchQueue.main.async {
                            self.tableViewInvited.reloadData()
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
        return invitedFriendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FriendInvitedCell
        
        cell.delegate = self
        
        cell.btnDecline.tag = indexPath.row
        cell.btnAccept.tag = indexPath.row

        let friend = invitedFriendList[indexPath.row]
        
        cell.labelName.text = friend["player2Name"] as? String
        
        if let base64String = friend["player2Pic"] {
            if let decodedData = NSData(base64Encoded: base64String as! String, options: []) {
                let decodedimage = UIImage(data: decodedData as Data)
                cell.ivInvited.image = decodedimage
            }
        }
                
        return cell
    }
    
    func btnDeclineOnClick(_ tag: Int) {
        deleteFriend(friend: invitedFriendList[tag])
    }
    
    func btnAcceptOnClick(_ tag: Int) {
        createFriend(friend: invitedFriendList[tag])
    }
    
    func createFriend(friend: [String: Any]) {
        // 利用URLSession與server溝通
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
                    
        let url = URL(string: "http://127.0.0.1:8080/Advertisement_Server/CreateFriend")
        var request : URLRequest = URLRequest(url: url!)

        // 利用POST方法傳給server
        request.httpMethod = "POST"

        let json: [String: Any] = [
            "player1Id": friend["player2Id"] as! String,
            "player2Id": "\(user)",
            "inviteStatus": 2,
            "pointCount": 0
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
                self.fetchInvitedFriendList()
                break
               case 400:
                  break
               default:
                  break
            }
        }
        
        dataTask.resume()
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
            "player1Id": friend["player2Id"] as! String,
            "player2Id": "\(user)"
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
                self.fetchInvitedFriendList()
                break
               case 400:
                  break
               default:
                  break
            }
        }
        
        dataTask.resume()
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
