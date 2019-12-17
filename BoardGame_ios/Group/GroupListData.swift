class GroupListData: Codable {
    var group_no: Int
    var group_name: String
    var setup_time: String
    var area_lv2: String
    
    public init(_ group_no: Int,_ group_name: String,_ setup_time: String,_ area_lv2: String) {
        self.group_name = group_name
        self.group_no = group_no
        self.area_lv2 = area_lv2
        self.setup_time = setup_time
    }
}
