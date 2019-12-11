//
//  ShowQRViewController.swift
//  BoardGame_ios
//
//  Created by 洪瑞奇 on 2019/12/10.
//  Copyright © 2019 黃國展. All rights reserved.
//

import UIKit

class ShowQRViewController: UIViewController {
    @IBOutlet weak var ivQRCode: UIImageView!
    
    @IBAction func showScanViewController(_ sender: Any) {
        let showQRCodeVC: ScanQRViewController = self.storyboard!.instantiateViewController(withIdentifier: "ScanQRCode") as! ScanQRViewController
        
        self.navigationController?.pushViewController(showQRCodeVC, animated: true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        var qrcodeImage: CIImage!
       
        // TODO: - 需拿到登入時存入的使用者資料
        let myProfile = [
            "id": "myself",
            "nkName": "我自己"
        ]
        
        let jsonMyProfile = try? JSONSerialization.data(withJSONObject: myProfile)

        let filter = CIFilter(name: "CIQRCodeGenerator")

        filter?.setValue(jsonMyProfile, forKey: "inputMessage")
        qrcodeImage = filter?.outputImage
        
        ivQRCode.image = UIImage(ciImage: qrcodeImage)
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
