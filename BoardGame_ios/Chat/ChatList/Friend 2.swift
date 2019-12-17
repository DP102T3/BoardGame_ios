//
//  Friend.swift
//  ChatTest_01
//
//  Created by Ryan Tsai on 2019/11/26.
//  Copyright © 2019 Ryan Tsai. All rights reserved.
//

import Foundation

struct Friend: Codable {
    var friendId = ""
    var friendNkName = ""
    var position: Int

    init(friendId: String, friendNkName: String, position: Int) {
        self.friendId = friendId
        self.friendNkName = friendNkName
        self.position = position
    }
}
