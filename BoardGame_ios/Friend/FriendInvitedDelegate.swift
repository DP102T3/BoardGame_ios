//
//  FriendInvitedDelegate.swift
//  BoardGame_ios
//
//  Created by 洪瑞奇 on 2019/12/9.
//  Copyright © 2019 黃國展. All rights reserved.
//

import Foundation

protocol FriendInvitedDelegate {
    func btnDeclineOnClick(_ tag: Int)
    func btnAcceptOnClick(_ tag: Int)
}
