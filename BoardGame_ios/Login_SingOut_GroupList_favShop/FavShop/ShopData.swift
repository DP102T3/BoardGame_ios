class ShopData: Codable {
    var shop_id: Int
    var shopName: String
    var address: String
    var rate: Double
    var latitude: Double?
    var longitude: Double?
    
    
    public init(_ shop_id: Int,_ shopName: String,_ address: String,_ rate: Double,_ latitude: Double,_ longitude: Double) {
        self.shop_id = shop_id
        self.shopName = shopName
        self.address = address
        self.rate = rate
        self.latitude = latitude
        self.longitude = longitude
    }
}
