//
//  RegisterDetailVC.swift
//  BoardGame_ios
//
//  Created by 洪瑞奇 on 2019/12/3.
//  Copyright © 2019 黃國展. All rights reserved.
//

import UIKit

class RegisterDetailVC: UIViewController {

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfNkName: UITextField!
    @IBOutlet weak var segmentGender: UISegmentedControl!
    @IBOutlet weak var tfBirthday: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectBirthday(_ sender: Any) {
        datePicker()
    }
    
    func datePicker(){
        // date picker setup
        let datePickerView:UIDatePicker = UIDatePicker()

        // choose the mode you want
        // other options are: DateAndTime, Time, CountDownTimer
        datePickerView.datePickerMode = UIDatePicker.Mode.date

        // choose your locale or leave the default (system)
        // datePickerView.locale = NSLocale.init(localeIdentifier: "it_IT")

        datePickerView.addTarget(self, action: Selector(("onDatePickerValueChanged:")), for: UIControl.Event.valueChanged)
        tfBirthday.inputView = datePickerView

        // datepicker toolbar setup
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: Selector(("doneDatePickerPressed")))

            // if you remove the space element, the "done" button will be left aligned
            // you can add more items if you want
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()

        tfBirthday.inputAccessoryView = toolBar

        var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            // customize the locale for the formatter if you want
            // formatter.locale = NSLocale(localeIdentifier: "it_IT")
            formatter.dateFormat = "MM 月 dd 日"
            return formatter
        }
        dateFormatter.string(from: datePickerView.date)
    }
    
    @IBAction func onSendClick(_ sender: Any) {
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

            let json: [String: Any] = ["name": "rich", "id": "iamrich"]
            // 假設這邊要註冊資料上傳 -> 先把註冊資訊的資料轉成jsonData
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            // {"name":"rich","id":"iamrich","mood":"happy"}

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
            }
            dataTask.resume()
        
//      若成功送出資料執行以下程式碼
            let controller = UIAlertController(title: "註冊結果", message: "註冊成功！", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
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
