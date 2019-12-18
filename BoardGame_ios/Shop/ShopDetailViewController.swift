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
    let url_server = URL(string: urlForFriendAndShop + "GetShops")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = shop.shopName
        
        self.labelId.text = String(shop.shopId)
        self.labelAdress.text = shop.shopAddress
        self.labelTel.text = String(shop.shopTel)
        self.labelIntro.text = shop.shopIntro
        self.labelCharge.text = shop.shopCharge
        let score = shop.rateTotal / Double(shop.rateCount)
        self.labelRate.text = String(format: "%.1f", score)
    
        var requestParam = [String: Any]()
        requestParam["action"] = "getShopImage"
        requestParam["shopId"] = shop.shopId
        requestParam["imageSize"] = 284
        
        executeTask(url_server!, requestParam) { (data, response, error) in
            var image: UIImage?
            if error == nil {
                print(requestParam)
                if let data = data {
                    if let base64String = String(data: data, encoding: .utf8) {
                        print(base64String)
                        if let decodedData = NSData(base64Encoded: base64String, options: []){
                            let decodedimage = UIImage(data: decodedData as Data)
                            image = decodedimage
                        }
                    }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let shopMapVC = segue.destination as! ShopMapVC
        shopMapVC.shop = shop
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
