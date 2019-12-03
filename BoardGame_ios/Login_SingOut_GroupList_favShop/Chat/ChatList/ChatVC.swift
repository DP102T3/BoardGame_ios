//
//  ViewController.swift
//  ChatTest_01
//
//  Created by Ryan Tsai on 2019/11/21.
//  Copyright © 2019 Ryan Tsai. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDataSource {
    // 建立假資料_使用者id、好友名單
    var playerId = ""
    var friends: [Friend]?
    var groups: [Group]?
    var image: String = ""
    var name: String = ""
    let url_server = URL(string: common_url + "ChatServlet")
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var listTableView: UITableView!
    // 實作 UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 除錯
        print("tableView_1")
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
        // 除錯
        print("tableView_2")
        let selectedIndex = segmentControl.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            if let friends = friends {
                image = getFriendImage(friendId: friends[indexPath.row].friendId)
                name = friends[indexPath.row].friendNkName
            }
        case 1:
            if let groups = groups {
                image = getGroupImage(groupNo: groups[indexPath.row].groupNo)
                name = groups[indexPath.row].groupName
            }
        default:
            break
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.cellId, for: indexPath) as? ChatTableViewCell
            else {
                return UITableViewCell()
        }
        cell.chatListImage.image = UIImage(named: image)
        cell.chatListName.text = name
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 除錯
        print("viewDidLoad")
        // Do any additional setup after loading the view.
        // 建立假資料，玩家Id
        saveUserDefaults("playerId", "chengchi1223")
        // 取用 UserDefaults 的玩家 id
        playerId = loadUserDefaults("playerId")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 除錯
        print("viewWillAppear")
        updateChatList()
        
        // 將已選取的cell取消選取（取消灰底）
        if let row = listTableView.indexPathForSelectedRow {
            listTableView.deselectRow(at: row, animated: true)
        }
        
    }
    
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        // 除錯
        print("segmentControlValueChanged")
        updateChatList()
        listTableView.reloadData()
    }
    
    func updateChatList() {
        // 除錯
        print("updateChatList")
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
                        
                        if let result = try? JSONDecoder().decode([Friend].self, from: data!) {
                            self.friends = result
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
                //                self.listTableView.reloadData()
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
                        
                        if let result = try? JSONDecoder().decode([Group].self, from: data!) {
                            self.groups = result
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
    
    // 圖檔假資料 -> 開執行緒取得圖片
    func getFriendImage(friendId: String) -> String {
        // 除錯
        print("getFriendImage")
        var imageStr = ""
        switch friendId {
        case "jerry1124":
            imageStr = "BG01"
        case "gerfarn0523":
            imageStr = "BG02"
        default:
            break
        }
        return imageStr
    }
    
    // 圖檔假資料 -> 開執行緒取得圖片
    func getGroupImage(groupNo: Int) -> String {
        // 除錯
        print("getGroupImage")
        var imageStr = ""
        switch groupNo {
        case 1:
            imageStr = "image"
        case 2:
            imageStr = "portrait_default"
        default:
            break
        }
        return imageStr
    }
}

