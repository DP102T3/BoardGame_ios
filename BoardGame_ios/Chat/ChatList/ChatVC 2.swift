//
//  ViewController.swift
//  ChatTest_01
//
//  Created by Ryan Tsai on 2019/11/21.
//  Copyright © 2019 Ryan Tsai. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDataSource {
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var listTableView: UITableView!
    
    // 建立假資料_使用者id、好友名單
    var playerId = ""
    var friends: [Friend]?
    var groups: [Group]?
    var name: String = ""
    let url_server = URL(string: common_url_forChat + "ChatServlet")
    
    // 實作 UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var inputNum = 0
        let selectedIndex = segmentControl.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            if let friends = friends {inputNum = friends.count}
        case 1:
            if let groups = groups {inputNum = groups.count}
        default:
            break
        }
        return inputNum
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectedIndex = segmentControl.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            if let friends = friends {
                name = friends[indexPath.row].friendNkName
            }
        case 1:
            if let groups = groups {
                name = groups[indexPath.row].groupName
            }
        default:
            break
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.cellId, for: indexPath) as? ChatTableViewCell
            else {
                return UITableViewCell()
        }
        
        
        // 從 Server 取得頭像
        var image: UIImage?
        
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["playerId"] = playerId
        requestParam["imageSize"] = 60
        switch selectedIndex {
        case 0:
            if let friends = friends {
                requestParam["idType"] = "String"
                requestParam["imageId"] = friends[indexPath.row].friendId
            }
        case 1:
            if let groups = groups {
                requestParam["idType"] = "int"
                requestParam["imageId"] = groups[indexPath.row].groupNo
            }
        default:
            break
        }
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // Server儲存的圖片
                    image = UIImage(data: data!)
                }
                if image == nil {
                    // 預設圖片
                    image = UIImage(named: "portrait_default")
                }
                DispatchQueue.main.async { cell.chatListImage.image = image }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        
        cell.chatListName.text = name
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 建立假資料，玩家Id -> 在登入時存入
        saveUserDefaults("playerId", "chengchi1223")
        // 取用 UserDefaults 的玩家 id
        playerId = loadUserDefaults("playerId")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 顯示Tab Bar
        self.tabBarController?.tabBar.isHidden = false
        updateChatList()
        
        // 將已選取的cell取消選取（取消灰底）
        if let row = listTableView.indexPathForSelectedRow {
            listTableView.deselectRow(at: row, animated: true)
        }
    }
    
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        updateChatList()
    }
    
    func updateChatList() {
        // 好友/揪團假資料 -> 連接Servlet取得 好友/已參團 清單
        let selectedIndex = segmentControl.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            // 好友清單假資料
            //            friends = [Friend(friendId: "jerry1124", friendNkName: "Jerry", position: 0), Friend(friendId: "gerfarn0523", friendNkName: "May", position: 1)]
            
            // 連接 Server 取得好友清單（action : searchFriends）
            var requestParam = [String: Any]()
            requestParam["action"] = "searchFriends"
            requestParam["playerId"] = playerId
            executeTask(url_server!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        // 將輸入資料列印出來除錯用
                        print("input: \(String(data: data!, encoding: .utf8)!)")
                        DispatchQueue.main.async {
                            if let result = try? JSONDecoder().decode([Friend].self, from: data!) {
                                self.friends = result
                            }
                            self.listTableView.reloadData()
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
            
        case 1:
            // 揪團清單假資料
            //            groups = [Group(groupNo: 1, groupName: "BG 01"), Group(groupNo: 2, groupName: "BG 02")]
            
            // 連接 Server 取得參團清單（action : searchJoinedGroups）
            var requestParam = [String: Any]()
            requestParam["action"] = "searchJoinedGroups"
            requestParam["playerId"] = playerId
            executeTask(url_server!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        // 將輸入資料列印出來除錯用
                        print("input: \(String(data: data!, encoding: .utf8)!)")
                        DispatchQueue.main.async {
                            if let result = try? JSONDecoder().decode([Group].self, from: data!) {
                                self.groups = result
                            }
                            self.listTableView.reloadData()
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
            
        default:
            break
        }
    }
    
    /* 因為拉UITableViewCell與detail頁面連結，所以sender是UITableViewCell */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let indexPath = self.listTableView.indexPathForSelectedRow
            let MsgVC = segue.destination as! MsgVC

            let selectedIndex = segmentControl.selectedSegmentIndex
            switch selectedIndex {
            case 0:
                var friend: Friend?
                if let friends = self.friends {
                    friend = friends[indexPath!.row]
                    MsgVC.friend = friend
                    MsgVC.state = 0
                }
            case 1:
                var group: Group?
                if let groups = self.groups {
                    group = groups[indexPath!.row]
                    MsgVC.group = group
                    MsgVC.state = 1
                }
            default:
                break
            }
    }
}

