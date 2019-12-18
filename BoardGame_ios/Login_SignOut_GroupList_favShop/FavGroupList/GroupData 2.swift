class GroupData: Codable {
    var group_name: String
    var group_no: Int
    var group_check: Int
    var setup_time: String
    
    public init(_ group_name: String,_ group_no: Int,_ group_check: Int,_ setup_time: String) {
        self.group_no = group_no
        self.group_name = group_name
        self.group_check = group_check
        self.setup_time = setup_time
    }
}
