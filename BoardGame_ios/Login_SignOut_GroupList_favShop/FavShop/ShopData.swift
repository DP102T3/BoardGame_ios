class ShopData: Codable {
    var shop_id: Int
    var shopName: String
    var address: String
    var rate_count: Int
    var rate_total: Int

    
    public init(_ shop_id: Int,_ shopName: String,_ address: String,_ rate_count: Int,_ rate_total: Int) {
        self.shop_id = shop_id
        self.shopName = shopName
        self.address = address
        self.rate_count = rate_count
        self.rate_total = rate_total
    }
}
