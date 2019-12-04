//
//  MsgVC.swift
//  ChatTest_01
//
//  Created by Ryan Tsai on 2019/11/21.
//  Copyright © 2019 Ryan Tsai. All rights reserved.
//

import UIKit

class MsgVC: UIViewController, UITableViewDataSource {
    
    // 從前一頁傳入的屬性
    var friend: Friend?
    // 準備放從 Server 取得的資料
    var image: UIImage?
    var msgs: [Msg]?
    
    // 實作 UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return msgs?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if msgs?[indexPath.row].type == 0 {
            // 送出的訊息
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MsgSendedTableViewCell.cellId, for: indexPath) as? MsgSendedTableViewCell else {
                return UITableViewCell()
            }
            cell.tvSended.text = msgs?[indexPath.row].content
            return cell
        } else if msgs?[indexPath.row].type == 1 {
            // 接收的訊息
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MsgReceivedTableViewCell.cellId, for: indexPath) as? MsgReceivedTableViewCell else {
                return UITableViewCell()
            }
            // 圖片假資料 -> 從 Server 取得頭像
            cell.imgPortrait.image = image ?? UIImage(named: "portrait_default")
            cell.tvReceived.text = msgs?[indexPath.row].content
            return cell
        }
        return UITableViewCell()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 隱藏Tab Bar
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // 建立假資料 -> 從 Server 取得頭像、聊天訊息
        image = UIImage(named: "image")
        msgs = [Msg(playerName: "Jerry", content: "Hi, Ryan 好久不見, 最近過得怎麼樣啊？", contentType: 0, type: 1), Msg(playerName: "Ryan", content: "還可以啦，跟平常一樣。\n要不要晚上一起出來吃個宵夜啊？\n3\n4\n5\n6\n7\n8\n9\n10", contentType: 0, type: 0)]
    }
    
    // 點擊發送按鈕後的事件處理
    @IBAction func onSendClick(_ sender: Any) {
        
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
