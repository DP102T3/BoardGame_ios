//
//  RegisterHomeVC.swift
//  BoardGame_ios
//
//  Created by 洪瑞奇 on 2019/12/4.
//  Copyright © 2019 黃國展. All rights reserved.
//

import UIKit

class RegisterHomeVC: UIViewController {

    @IBOutlet weak var tfAccount: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfPwConfirmed: UITextField!
    @IBOutlet weak var hintAccount: UILabel!
    @IBOutlet weak var hintPw: UILabel!
    @IBOutlet weak var hintPwCheck: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tfAccount.addTarget(self, action: #selector(tfAccountDidChange), for: .editingChanged)
        
        tfPassword.addTarget(self, action: #selector(tfPasswordDidChange), for: .editingChanged)
        
        tfPwConfirmed.addTarget(self, action: #selector(tfPwConfirmedDidChange), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is RegisterDetailVC {
            let vc = segue.destination as! RegisterDetailVC
            vc.account = tfAccount.text!
            vc.pwd = tfPassword.text!
        }
    }
    
    @objc func tfAccountDidChange() {
        
        if tfAccount.text == "" {
            hintAccount.isHidden = true
            return
        }
        
        let accountLength: Int = tfAccount.text!.count
        
        if (accountLength < 6 || accountLength > 12 ) {
            hintAccount.isHidden = false
        } else {
            hintAccount.isHidden = true
        }
    }
    
    @objc func tfPasswordDidChange() {
        if tfPassword.text == "" {
            hintPw.isHidden = true
            return
        }
        
        let pwdLength: Int = tfPassword.text!.count
        
        if (pwdLength < 6 || pwdLength > 12 ) {
            hintPw.isHidden = false
        } else {
            hintPw.isHidden = true
        }
        
        tfPwConfirmedDidChange()
    }
    
    @objc func tfPwConfirmedDidChange() {
        if tfPwConfirmed.text == "" {
            hintPwCheck.isHidden = true
            return
        }
                
        if (tfPwConfirmed.text != tfPassword.text) {
            hintPwCheck.isHidden = false
        } else {
            hintPwCheck.isHidden = true
        }
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
