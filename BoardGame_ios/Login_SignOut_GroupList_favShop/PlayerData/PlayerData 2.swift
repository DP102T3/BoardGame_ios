class PlayerData: Codable {
    var player_nkname: String
    var player_gender: Int
    var player_bday: String
    var player_area: String
    var player_star: String
    var fav_bg: String
    var adept_bg: String
    var player_intro: String
    
    
    public init(_ player_nkname: String,_ player_gender: Int,_ player_bday: String,_ player_area: String,_ player_star: String,_ fav_bg:String,_ adept_bg:String,_ player_intro:String) {
        self.player_nkname = player_nkname
        self.player_gender = player_gender
        self.player_bday = player_bday
        self.player_area = player_area
        self.player_star = player_star
        self.fav_bg = fav_bg
        self.adept_bg = adept_bg
        self.player_intro = player_intro
    }
}
