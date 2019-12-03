
import UIKit

class FavShopCell: UITableViewCell {
    @IBOutlet weak var ivFavShop: UIImageView!
    @IBOutlet weak var lbShopName: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbRate: UILabel!
    
    var delegate: favShopVCCellDelegate?

    
    @IBAction func mapOnClick(_ sender: Any) {
        delegate?.favShopVCCellOnClick(self)
    }
    
}
