
import UIKit

class FavShopCell: UITableViewCell {
    @IBOutlet weak var ivFavShop: UIImageView!
    @IBOutlet weak var lbShopName: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbRate: UILabel!
    @IBOutlet weak var btMap: UIButton!
    
    var delegate: FavShopVCCellDelegate?

    @IBAction func openMap(_ sender: UIButton) {
        delegate?.favShopVCCellOnClick(self)
    }
}
