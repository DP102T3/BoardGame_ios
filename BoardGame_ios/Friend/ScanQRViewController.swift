//
//  ScanQRViewController.swift
//  BoardGame_ios
//
//  Created by 洪瑞奇 on 2019/12/10.
//  Copyright © 2019 黃國展. All rights reserved.
//

import UIKit
import AVFoundation

class ScanQRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, ScanQRCodeDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tvScanResult: UITableView!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    let user = loadUserDefaults("player_id")

    var friend: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                guard success == true else { return }
                self.openCameraForScan()
            }
        case .denied, .restricted:
            let alertController = UIAlertController (title: "相機啟用失敗", message: "相機服務未啟用", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "設定", style: .default) { (_) -> Void in

                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "確認", style: .default, handler: nil)
            alertController.addAction(cancelAction)

            self.present(alertController, animated: true, completion: nil)
            return
        case .authorized:
            print("Authorized, proceed")
            self.openCameraForScan()
        @unknown default:
            fatalError()
        }
                
        tvScanResult.dataSource = self
        tvScanResult.dataSource = self
    }
    
    func openCameraForScan() {
        // 取得 AVCaptureDevice 類別的實體來初始化一個device物件，並提供video
        // 作為媒體型態參數
         
        captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to get the camera device")
            return
        }
         
        do {
            // 使用前一個裝置物件來取得 AVCaptureDeviceInput 類別的實例
            let input = try AVCaptureDeviceInput(device: captureDevice)

            // 在擷取 session 設定輸入裝置
            captureSession!.addInput(input)
            
            // 初始化一個 AVCaptureMetadataOutput 物件並將其設定做為擷取 session 的輸出裝置
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession!.addOutput(captureMetadataOutput)
            
            // 設定委派並使用預設的調度佇列來執行回呼（call back）
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            DispatchQueue.main.async {
                // 初始化影片預覽層，並將其作為子層加入 viewPreview 視圖的圖層中
                self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
                self.videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                self.videoPreviewLayer?.frame = self.view.layer.bounds
                self.view.layer.addSublayer(self.videoPreviewLayer!)
                           
                // 開始影片的擷取
                self.captureSession!.startRunning()
            }
            
              

        } catch {
            // 假如有錯誤產生、單純輸出其狀況不再繼續執行
            print(error)
            return
        }
    }
    
    func closeQRCodeScanner() {
        captureSession?.stopRunning()
        videoPreviewLayer?.removeFromSuperlayer()
        qrCodeFrameView?.frame = CGRect.zero
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // 檢查 metadataObjects 陣列是否為非空值，它至少需包含一個物件
           
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            print("error")
             
            return
        }
        
        // 取得元資料（metadata）物件
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
               
            //倘若發現的原資料與 QR code 原資料相同，便更新狀態標籤的文字並設定邊界
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj as
                AVMetadataMachineReadableCodeObject)
            qrCodeFrameView?.frame = barCodeObject!.bounds;
               
            if metadataObj.stringValue != nil {
                print(metadataObj.stringValue ?? "empty")
                parseFriendProfile(metadataObj.stringValue!)
            }
        }
    }
    
    func parseFriendProfile(_ jsonString: String) {
        if let json = (try? JSONSerialization.jsonObject(with: jsonString.data(using: .utf8)!, options: [])) as? [String: Any] {
            print(json)
            print(json["frNkName"] ?? "empty name")
            print(json["frID"] ?? "empty id")
            
            friend = [
                "id": json["frID"] ?? "",
                "nkName": json["frNkName"] ?? ""
            ]
            
            closeQRCodeScanner()
            
            self.tvScanResult.reloadData()
        }
    }
    
    func onBtnInviteOnClick(_ tag: Int) {
        inviteFriend(friend!)
    }
    
    func inviteFriend(_ friend: [String: Any]) {
        // 利用URLSession與server溝通
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
                    
        let url = URL(string: "http://127.0.0.1:8080/Advertisement_Server/CreateFriend")
        var request : URLRequest = URLRequest(url: url!)

        // 利用POST方法傳給server
        request.httpMethod = "POST"

        let json: [String: Any] = [
            "player1Id": "\(user)",
            "player2Id": friend["id"] as! String,
            "inviteStatus": 1,
            "pointCount": 0
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
                    
        print(String(data: jsonData!, encoding: .utf8)!)
        // 放入body
        request.httpBody = jsonData

        // 把request利用session.dataTask傳給目標server
        let dataTask = session.dataTask(with: request) { data,response,error in
            // 如果沒有response則show error
            guard let httpResponse = response as? HTTPURLResponse
           
            else {
              print("error: not a valid http response")
              return
            }
            
            switch (httpResponse.statusCode) {
               case 200: //success response.
                self.navigationController?.popToRootViewController(animated: true)
                break
               case 400:
                  break
               default:
                  break
            }
        }
        
        dataTask.resume()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friend == nil ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ScanQRCodeCell
                
        cell.delegate = self

        cell.btnInvite.tag = indexPath.row

        cell.labelName.text = friend!["nkName"] as? String
             
        return cell
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
