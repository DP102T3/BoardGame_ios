//
//  Shop.swift
//  BoardGame_ios
//
//  Created by 洪瑞奇 on 2019/12/16.
//  Copyright © 2019 黃國展. All rights reserved.
//

class Shop: Codable {
    var shopId: Int
    var shopName: String
    var shopAddress: String?
    var shopTel: Int
    var shopIntro: String?
    var rateTotal: Double
    var rateCount: Int
    var shopCharge: String?
    var timeOpen: String
    var timeClose: String
    var shopCap: Int
    
    public init(_ shopId: Int,_ shopName: String,_ shopAddress: String,_ shopTel: Int,_ shopIntro: String,_ rateTotal: Double,_ rateCount: Int,_ shopCharge: String,_ timeOpen: String,_ timeClose: String,_ shopCap: Int) {
        self.shopId = shopId
        self.shopName = shopName
        self.shopAddress = shopAddress
        self.shopTel = shopTel
        self.shopIntro = shopIntro
        self.rateTotal = rateTotal
        self.rateCount = rateCount
        self.shopCharge = shopCharge
        self.timeOpen = timeOpen
        self.timeClose = timeClose
        self.shopCap = shopCap
    }
}
