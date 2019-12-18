//
//  PlayerDataUpdate.swift
//  BoardGame_ios
//
//  Created by 黃國展 on 2019/12/10.
//  Copyright © 2019 黃國展. All rights reserved.
//

import UIKit

class PlayerDataUpdateTVC: UITableViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var ivPlayer: UIImageView!
    @IBOutlet weak var lbPlayer_nkname: UITextField!
    @IBOutlet weak var lbPlayer_gender: UITextField!
    @IBOutlet weak var lbPlayer_bday: UITextField!
    @IBOutlet weak var lbPlayer_area: UITextField!
    @IBOutlet weak var lbPlayer_star: UITextField!
    @IBOutlet weak var lbFav_bg: UITextField!
    @IBOutlet weak var lbAdept_bg: UITextField!
    @IBOutlet weak var tvPerson: UITextView!
    @IBOutlet weak var lbresult: UILabel!
    
    let url_server = URL(string: common_url + "FavServlet")
    var imageUpload: UIImage?
    var player_id = loadUserDefaults("player_id")

    
    override func viewDidLoad() {
        addKeyboardObserver()
        //showPlayerData()
        textLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showPlayerData()
    }
    
    @IBAction func clickTakePicture(_ sender: Any) {
        imagePicker(type: .camera)
    }
    
    @IBAction func clickPickPicture(_ sender: Any) {
        imagePicker(type: .photoLibrary)
    }
    
    func imagePicker(type: UIImagePickerController.SourceType) {
        hideKeyboard()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = type
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let playerImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // 拍照或挑選的照片視為要上傳更新的照片
            imageUpload = playerImage
            ivPlayer.image = playerImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickUpdate(_ sender: Any) {
        PlayerTVC.playerData?.player_nkname = lbPlayer_nkname.text == nil ? "" : lbPlayer_nkname.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        PlayerTVC.playerData?.player_bday = lbPlayer_bday.text == nil ? "" : lbPlayer_bday.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        PlayerTVC.playerData?.player_area = lbPlayer_area.text == nil ? "" : lbPlayer_area.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        PlayerTVC.playerData?.player_star = lbPlayer_star.text == nil ? "" : lbPlayer_star.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        PlayerTVC.playerData?.adept_bg = lbAdept_bg.text == nil ? "" : lbAdept_bg.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        PlayerTVC.playerData?.fav_bg = lbFav_bg.text == nil ? "" : lbFav_bg.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        PlayerTVC.playerData?.player_intro = tvPerson.text == nil ? "" : tvPerson.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var requestParam = [String: String]()
        requestParam["action"] = "playerUpdate"
        requestParam["player_id"] = player_id
        requestParam["playerUpdateData"] = try! String(data: JSONEncoder().encode(PlayerTVC.playerData), encoding: .utf8)
        if self.imageUpload != nil {
            requestParam["imageBase64"] = self.imageUpload!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
        }
        executeTask(self.url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                // 新增成功則回前頁
                                if count != 0 {
                                    if let controllers = self.navigationController?.viewControllers {
                                        for vc in controllers {
                                            if vc is FavShopVC_{
                                                self.navigationController?.popToViewController(vc, animated: true)
                                            }
                                        }
                                    }
                                    
                                } else {
                                    self.lbresult.text = "update fail"
                                }
                            }
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
  }
    
    func showPlayerData() {
        textLabel()
        // 利用spot ID去server端取對應照片
        var requestParam = [String: Any]()
        requestParam["action"] = "getPlayerImage"
        requestParam["player_id"] = player_id
        // 圖片寬度 = 螢幕寬度的ㄉ/2
        requestParam["imageSize"] = view.frame.width/2
        executeTask(url_server!, requestParam) { (data, response, error) in
            var image: UIImage?
            if data != nil {
                image = UIImage(data: data!)
            }
            if image == nil {
                image = UIImage(named: "noImage.jpg")
            }
            DispatchQueue.main.async { self.ivPlayer.image = image }
        }
    }
    
    @IBAction func didEndOnExit(_ sender: Any) { }
}

extension PlayerDataUpdateTVC {
    func hideKeyboard() {
        lbPlayer_nkname.resignFirstResponder()
        lbPlayer_gender.resignFirstResponder()
        lbPlayer_bday.resignFirstResponder()
        lbPlayer_area.resignFirstResponder()
        lbPlayer_star.resignFirstResponder()
        lbFav_bg.resignFirstResponder()
        lbAdept_bg.resignFirstResponder()
        tvPerson.resignFirstResponder()
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        // 能取得鍵盤高度就讓view上移鍵盤高度，否則上移view的1/3高度
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            view.frame.origin.y = -keyboardHeight / 2
        } else {
            view.frame.origin.y = -view.frame.height / 3
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //將servlet傳回的值放入lable顯示
    func textLabel(){
        lbPlayer_nkname.text = PlayerTVC.playerData?.player_nkname
        lbPlayer_bday.text = PlayerTVC.playerData?.player_bday
        lbPlayer_area.text = PlayerTVC.playerData?.player_area
        lbPlayer_star.text = PlayerTVC.playerData?.player_star
        lbFav_bg.text = PlayerTVC.playerData?.adept_bg
        lbAdept_bg.text = PlayerTVC.playerData?.adept_bg
        tvPerson.text = PlayerTVC.playerData?.player_intro
        
        //判斷為男性還是女性
        let gender_int = PlayerTVC.playerData?.player_gender
        var gender: String
        if gender_int == 0 {
            gender = "男性"
        }else{
            gender = "女性"
        }
        lbPlayer_gender.text = gender
    }
    
    func showAlert(_ message: String,_ viewController: UITableViewController) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancel)
        /* 呼叫present()才會跳出Alert Controller */
        viewController.present(alertController, animated: true, completion:nil)
    }
}
