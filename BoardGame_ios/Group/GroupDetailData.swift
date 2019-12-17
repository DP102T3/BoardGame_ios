class GroupDetailData: Codable {
    var group_name: String
    var shop_name: String
    var time_start: String
    var time_end: String
    var area_lv2: String
    var area_lv3: String
    var np_lower: Int
    var np_upper: Int
    var group_np: Int
    var game_type: String
    var game_name: String
    var game_budget: Int
    var signup_time: String
    var other_info: String

    
    public init(_ group_name: String,_ shop_name: String,_ time_start: String,_ time_end: String,_ area_lv2: String,_ area_lv3: String,_ np_lower: Int,_ np_upper: Int,_ group_np: Int,_ game_type: String,_ game_name: String,_ game_budget: Int,_ signup_time:String,_ other_info: String) {
        self.group_name = group_name
        self.shop_name = shop_name
        self.time_start = time_start
        self.time_end = time_end
        self.area_lv2 = area_lv2
        self.area_lv3 = area_lv3
        self.np_lower = np_lower
        self.np_upper = np_upper
        self.group_np = group_np
        self.game_type = game_type
        self.game_name = game_name
        self.game_budget = game_budget
        self.signup_time = signup_time
        self.other_info = other_info
    }
}
