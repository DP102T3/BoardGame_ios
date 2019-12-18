//
//  MsgVC.swift
//  ChatTest_01
//
//  Created by Ryan Tsai on 2019/11/21.
//  Copyright © 2019 Ryan Tsai. All rights reserved.
//

import UIKit

class MsgVC: UIViewController, UITableViewDataSource {
    @IBOutlet weak var msgsTableView: UITableView!
    @IBOutlet weak var tfMessage: UITextField!
    
    var playerId = ""
    let url_server = URL(string: common_url_forChat + "ChatServlet")
    
    // 從前一頁傳入的屬性
    var friend: Friend?
    var group: Group?
    var state = -1
    // 準備放從 Server 取得的資料
    var msgs: [Msg]?
    
    // 實作 UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return msgs?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if msgs?[indexPath.row].type == 0 {
            
            // ＊＊＊＊＊＊＊＊＊＊送出的訊息＊＊＊＊＊＊＊＊＊＊
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MsgSendedTableViewCell.cellId, for: indexPath) as? MsgSendedTableViewCell else {
                return UITableViewCell()
            }
            cell.tvSended.text = msgs?[indexPath.row].content
            return cell
            // ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
            
        } else if msgs?[indexPath.row].type == 1 {
            
            // ＊＊＊＊＊＊＊＊＊＊接收的訊息＊＊＊＊＊＊＊＊＊＊
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MsgReceivedTableViewCell.cellId, for: indexPath) as? MsgReceivedTableViewCell else {
                return UITableViewCell()
            }
            // 從 Server 取得頭像
            var image: UIImage?
            
            var requestParam = [String: Any]()
            requestParam["action"] = "getImage"
            requestParam["playerId"] = playerId
            requestParam["imageSize"] = 60
            switch state {
            case 0:
                if let friend = friend {
                    requestParam["idType"] = "String"
                    requestParam["imageId"] = friend.friendId
                }
            case 1:
                if let group = group {
                    requestParam["idType"] = "int"
                    requestParam["imageId"] = group.groupNo
                }
            default:
                break
            }
            executeTask(url_server!, requestParam) { (data, response, error) in
                // 除錯
                print("getImage_executeTask")
                if error == nil {
                    if data != nil {
                        // Server儲存的圖片
                        image = UIImage(data: data!)
                    }
                    if image == nil {
                        // 預設圖片
                        image = UIImage(named: "portrait_default")
                    }
                    DispatchQueue.main.async { cell.imgPortrait.image = image }
                } else {
                    print(error!.localizedDescription)
                }
            }
            cell.tvReceived.text = msgs?[indexPath.row].content
            return cell
            // ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
        }
        return UITableViewCell()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 點擊背景隱藏鍵盤
        addKeyboardObserver()
        // 隱藏Tab Bar
        self.tabBarController?.tabBar.isHidden = true
        // 建立假資料，玩家Id -> 在登入時存入
        saveUserDefaults("playerId", "chengchi1223")
        // 取用 UserDefaults 的玩家 id
        playerId = loadUserDefaults("playerId")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 變更標題（改為聊天對象名稱）
        switch state {
        case 0:
            if let friend = friend{
                self.title = friend.friendNkName
            }
        case 1:
            if let group = group{
                self.title = group.groupName
            }
        default:
            break
        }
        
        // 從 Server 取得聊天訊息
        updateMsgList()
        
        // Msg假資料
        //        msgs = [Msg(playerName: "Jerry", content: "Hi, Ryan 好久不見, 最近過得怎麼樣啊？", contentType: 0, type: 1), Msg(playerName: "Ryan", content: "還可以啦，跟平常一樣。\n要不要晚上一起出來吃個宵夜啊？\n3\n4\n5\n6\n7\n8\n9\n10", contentType: 0, type: 0)]
    }
    
    func updateMsgList(){
        switch state {
        case 0:
            // 連接 Server 取得私聊內容（action : searchChatFriend）
            if let friend = self.friend{
                var requestParam = [String: Any]()
                requestParam["action"] = "searchChatFriend"
                requestParam["playerId"] = playerId
                requestParam["friendId"] = friend.friendId
                requestParam["position"] = friend.position
                executeTask(url_server!, requestParam) { (data, response, error) in
                    if error == nil {
                        if data != nil {
                            // 將輸入資料列印出來除錯用
                            print("input: \(String(data: data!, encoding: .utf8)!)")
                            DispatchQueue.main.async {
                                if let result = try? JSONDecoder().decode([Msg].self, from: data!) {
                                    self.msgs = result
                                }
                                self.msgsTableView.reloadData()
                            }
                        }
                    } else {
                        print(error!.localizedDescription)
                    }
                }
            }
        case 1:
            // 連接 Server 取得團聊內容（action : searchChatGroup）
            if let group = self.group{
                var requestParam = [String: Any]()
                requestParam["action"] = "searchChatGroup"
                requestParam["playerId"] = playerId
                requestParam["groupNo"] = group.groupNo
                executeTask(url_server!, requestParam) { (data, response, error) in
                    if error == nil {
                        if data != nil {
                            // 將輸入資料列印出來除錯用
                            print("input: \(String(data: data!, encoding: .utf8)!)")
                            DispatchQueue.main.async {
                                if let result = try? JSONDecoder().decode([Msg].self, from: data!) {
                                    self.msgs = result
                                }
                                self.msgsTableView.reloadData()
                            }
                        }
                    } else {
                        print(error!.localizedDescription)
                    }
                }
            }
        default:
            break
        }
    }
    
    // 點擊發送按鈕後的事件處理
    @IBAction func onSendClick(_ sender: Any) {
        tfMessage.text = ""
    }
    
    /* 點擊虛擬鍵盤上return鍵會隱藏虛擬鍵盤 */
    @IBAction func didEndOnExit(_ sender: Any) { }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}


extension MsgVC {
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        // 能取得鍵盤高度就讓view上移鍵盤高度，否則上移view的1/3高度
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            view.frame.origin.y = 35 - keyboardHeight
        } else {
            view.frame.origin.y = -view.frame.height / 3
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
