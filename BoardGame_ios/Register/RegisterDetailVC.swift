//
//  RegisterDetailVC.swift
//  BoardGame_ios
//
//  Created by 洪瑞奇 on 2019/12/4.
//  Copyright © 2019 黃國展. All rights reserved.
//

import UIKit

class RegisterDetailVC: UIViewController {

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfNkName: UITextField!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tfBirthday: UITextField!
    
    var account: String = ""
    var pwd: String = ""
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        // customize the locale for the formatter if you want
        // formatter.locale = NSLocale(localeIdentifier: "it_IT")
        formatter.dateFormat = "MM 月 dd 日"
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("My account is \(account)")
        
        // Do any additional setup after loading the view.
        datePicker()
    }
    
    @IBAction func pickBirthday(_ sender: Any) {
        datePicker()
    }
    
    @IBAction func onSendClick(_ sender: Any) {
        
        if (tfName.text == "") {
            
            tfName.layer.borderColor = UIColor.red.cgColor
            tfName.layer.borderWidth = 1
            tfName.layer.cornerRadius = 6
        }
        
        if (tfNkName.text == "") {
            tfNkName.layer.borderColor = UIColor.red.cgColor
            tfNkName.layer.borderWidth = 1
            tfNkName.layer.cornerRadius = 6
        }
        
        if (tfBirthday.text == "") {
            tfBirthday.layer.borderColor = UIColor.red.cgColor
            tfBirthday.layer.borderWidth = 1
            tfBirthday.layer.cornerRadius = 6
        }
        
        if (tfName.text == "" || tfNkName.text == "" || tfBirthday.text == "") {
            
            return
        }
        
         let controller = UIAlertController(title: "送出註冊資料", message: "以上資料不可修改，請確認是否送出？", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                    // 利用URLSession與server溝通
                    let configuration = URLSessionConfiguration.default
                    let session = URLSession(configuration: configuration)

                    // 準備要傳給server的request
                    let url = URL(string: "http://localhost:8080/Advertisement_Server/Register")
                    var request : URLRequest = URLRequest(url: url!)

                    // 利用POST方法傳給server
                    request.httpMethod = "POST"

                    let json: [String: Any] = [
                        "id": self.account,
                        "pwd": self.pwd,
                        "name": self.tfName.text!,
                        "nkname": self.tfNkName.text!,
                        "bday": self.tfBirthday.text!,
                        "gender": self.segment.selectedSegmentIndex,
                    ]
                    // 假設這邊要註冊資料上傳 -> 先把註冊資訊的資料轉成jsonData
                    let jsonData = try? JSONSerialization.data(withJSONObject: json)
                    print("Send to Server: \(json)")
                    // {"name":"rich","id":"iamrich","mood":"happy"}

                    // 放入body
                    request.httpBody = jsonData

                    // 把request利用session.dataTask傳給目標server
                    let dataTask = session.dataTask(with: request) { data,response,error in
                        // 如果沒有response則show error
                        guard (response as? HTTPURLResponse) != nil
                       else {
                          print("error: not a valid http response")
                          return
                       }
                    }
                    dataTask.resume()
                
        //      若成功送出資料執行以下程式碼
                    let controller = UIAlertController(title: "註冊結果", message: "註冊成功！", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
                    
                    let okDemoAction = UIAlertAction(title: "確定", style: .default) { (action) in
                        DispatchQueue.main.async {
                            self.backToLogin()
                        }
                    }
                    controller.addAction(okDemoAction)
                    self.present(controller, animated: true, completion: nil)
                }
        
                controller.addAction(okAction)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                controller.addAction(cancelAction)
                present(controller, animated: true, completion: nil)
    }
    
    func backToLogin() {
        print("ddd")
        let next = storyboard?.instantiateViewController(withIdentifier: "loginvc") as! LoginVC
        next.modalPresentationStyle = .fullScreen
        present(next, animated: true)
        // self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func datePicker(){
        // date picker setup
        let datePickerView:UIDatePicker = UIDatePicker()

        // choose the mode you want
        // other options are: DateAndTime, Time, CountDownTimer
        datePickerView.datePickerMode = UIDatePicker.Mode.date

        // choose your locale or leave the default (system)
        // datePickerView.locale = NSLocale.init(localeIdentifier: "it_IT")

        datePickerView.addTarget(self, action: #selector(onDatePickerValueChanged), for: UIControl.Event.valueChanged)
        tfBirthday.inputView = datePickerView

        // datepicker toolbar setup
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneDatePickerPressed))

            // if you remove the space element, the "done" button will be left aligned
            // you can add more items if you want
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()

        tfBirthday.inputAccessoryView = toolBar

        dateFormatter.string(from: datePickerView.date)
    }
    
    @objc func onDatePickerValueChanged(datePicker: UIDatePicker) {
        
        tfBirthday.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func doneDatePickerPressed() {
        print("done")
        tfBirthday.endEditing(true)
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
