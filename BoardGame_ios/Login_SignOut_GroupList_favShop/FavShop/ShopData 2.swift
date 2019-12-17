class ShopData: Codable {
    var shop_id: Int
    var shopName: String
    var address: String
    var rate: Double
    
    
    public init(_ shop_id: Int,_ shopName: String,_ address: String,_ rate: Double) {
        self.shop_id = shop_id
        self.shopName = shopName
        self.address = address
        self.rate = rate
    }
}
