//
//  ShopDetailViewController.swift
//  BoardGame_ios
//
//  Created by 洪瑞奇 on 2019/12/16.
//  Copyright © 2019 黃國展. All rights reserved.
//

import UIKit

class ShopDetailViewController: UIViewController {
    @IBOutlet weak var ivShop: UIImageView!
    @IBOutlet weak var labelId: UILabel!
    
    @IBOutlet weak var labelCharge: UILabel!
    
    @IBOutlet weak var labelRate: UILabel!
    @IBOutlet weak var labelAdress: UILabel!
    
    @IBOutlet weak var labelTel: UILabel!
    
    @IBOutlet weak var labelIntro: UILabel!
    
    var shop: Shop!
    let url_server = URL(string: common_url + "SignupServlet")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.title = shop.shopName
        
        self.labelId.text = String(shop.shopId)
        self.labelAdress.text = shop.shopAddress
        self.labelTel.text = String(shop.shopTel)
        self.labelIntro.text = shop.shopIntro
        self.labelCharge.text = shop.shopCharge
        self.labelRate.text = String(shop.rateTotal / Double(shop.rateCount))
        
        var requestParam = [String: Any]()
        requestParam["action"] = "getShopImage"
        requestParam["shopId"] = shop.shopId
        requestParam["imageSize"] = 284
        
        executeTask(url_server!, requestParam) { (data, response, error) in
            var image: UIImage?
            if error == nil {
                print(requestParam)
                if data != nil {
                    image = UIImage(data: data!)
                }
                if image == nil {
                    image = UIImage(named: "noImage.jpg")
                }
                DispatchQueue.main.async { self.ivShop.image = image }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func onBtnPhoneClick(_ sender: Any) {
        guard let number = URL(string: "tel://\(shop.shopTel)") else { return }
        UIApplication.shared.open(number)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
