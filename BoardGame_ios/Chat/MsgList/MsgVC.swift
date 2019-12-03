//
//  MsgVC.swift
//  ChatTest_01
//
//  Created by Ryan Tsai on 2019/11/21.
//  Copyright © 2019 Ryan Tsai. All rights reserved.
//

import UIKit

class MsgVC: UIViewController, UITableViewDataSource {
    
    // 建立假資料
    var friend: Friend?
    var msgs: [Msg]? = [Msg(playerName: "Jerry", content: "Hi, Ryan 好久不見, 最近過得怎麼樣啊？", contentType: 0, type: 1), Msg(playerName: "Ryan", content: "還可以啦，跟平常一樣。\n要不要晚上一起出來吃個宵夜啊？\n3\n4\n5\n6\n7\n8\n9\n10", contentType: 0, type: 0)]

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
            cell.imgPortrait.image = UIImage(named: "image")
            cell.tvReceived.text = msgs?[indexPath.row].content
            return cell
            }
        return UITableViewCell()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBOutlet weak var onSendClicked: NSLayoutConstraint!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
