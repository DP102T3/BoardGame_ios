//
//  Msg.swift
//  ChatTest_01
//
//  Created by Ryan Tsai on 2019/11/21.
//  Copyright © 2019 Ryan Tsai. All rights reserved.
//

import Foundation

class Msg: Codable{
    var playerName = ""
    var content = ""
    var contentType: Int
    var type: Int
    static let TYPE_PLAYER_SEND = 0
    static let TYPE_RECEIVED = 1

    init(playerName: String, content: String, contentType: Int, type: Int) {
        self.playerName = playerName
        self.content = content
        self.contentType = contentType
        self.type = type
    }
}
