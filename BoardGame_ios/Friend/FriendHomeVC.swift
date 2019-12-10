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
    @IBOutlet weak var containerView: UIView!
    
    var friendAllVC: FriendAllVC!
    
    lazy var friendInvitedVC: FriendInvitedVC = {
       self.storyboard!.instantiateViewController(withIdentifier: "FriendInvited") as! FriendInvitedVC
    }()
    
    lazy var friendInvitingVC: FriendInvitingVC = {
       self.storyboard!.instantiateViewController(withIdentifier: "FriendInviting") as! FriendInvitingVC
    }()
    
    var currentViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currentViewController = friendAllVC
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendAllSegue" {
            friendAllVC = (segue.destination as! FriendAllVC)
        }
    }
    
    func changePage(to newViewController: UIViewController) {
        currentViewController.willMove(toParent: nil)
        currentViewController.view.removeFromSuperview()
        currentViewController.removeFromParent()

        addChild(newViewController)
        self.containerView.addSubview(newViewController.view)
        newViewController.view.frame = containerView.bounds
        newViewController.didMove(toParent: self)

        self.currentViewController = newViewController
    }
    
    @IBAction func viewChange(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            changePage(to: friendAllVC)
        } else if sender.selectedSegmentIndex == 1 {
            changePage(to: friendInvitedVC)
        } else {
            changePage(to: friendInvitingVC)
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
