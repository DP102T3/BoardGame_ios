class GroupData: Codable {
    var group_no: Int
    var group_Name: String
    var group_check: Int
    var long_time: CLong
    
    public init(_ group_no: Int,_ group_Name: String,_ group_check: Int,_ long_time: CLong) {
        self.group_no = group_no
        self.group_Name = group_Name
        self.group_check = group_check
        self.long_time = long_time
    }
}
