class GroupData: Codable {
    var group_id: Int
    var group_Name: String
    var group_check: Int
    var setup_time: Double
    
    public init(_ group_id: Int,_ group_Name: String,_ group_check: Int,_ setup_time: Double) {
        self.group_id = group_id
        self.group_Name = group_Name
        self.group_check = group_check
        self.setup_time = setup_time
    }
}
