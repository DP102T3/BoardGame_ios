//
//  FriendHomeVC.swift
//  BoardGame_ios
//
//  Created by 洪瑞奇 on 2019/12/4.
//  Copyright © 2019 黃國展. All rights reserved.
//

import UIKit

class FriendHomeVC: UIViewController {

    @IBOutlet weak var segment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.children[0].view.isHidden = false
        self.children[1].view.isHidden = true
        self.children[2].view.isHidden = true
    }
    
    @IBAction func viewChange(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            self.children[0].view.isHidden = false
            self.children[1].view.isHidden = true
            self.children[2].view.isHidden = true
        } else if sender.selectedSegmentIndex == 1 {
            self.children[0].view.isHidden = true
            self.children[1].view.isHidden = false
            self.children[2].view.isHidden = true
        } else {
            self.children[0].view.isHidden = true
            self.children[1].view.isHidden = true
            self.children[2].view.isHidden = false
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
