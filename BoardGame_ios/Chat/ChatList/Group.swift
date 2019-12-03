//
//  Group.swift
//  ChatTest_01
//
//  Created by Ryan Tsai on 2019/11/26.
//  Copyright © 2019 Ryan Tsai. All rights reserved.
//

import Foundation

struct Group: Codable {
    var groupNo: Int
    var groupName = ""

    init(groupNo: Int, groupName: String) {
        self.groupNo = groupNo
        self.groupName = groupName
    }
}
