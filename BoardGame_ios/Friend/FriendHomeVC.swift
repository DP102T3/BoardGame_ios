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
    
    lazy var showQRCodeVC: ShowQRViewController = {
       self.storyboard!.instantiateViewController(withIdentifier: "ShowQRCode") as! ShowQRViewController
    }()
    
    var currentViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currentViewController = friendAllVC
        
        
//        let addButton: UIButton = UIButton (type: UIButton.ButtonType.custom)
//        addButton.setImage(UIImage(named: "fr_add"), for: .normal)
//        addButton.addTarget(self, action: #selector(self.doneBarButtonTapped(sender:)), for: UIControl.Event.touchUpInside)
//        addButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        let barButton = UIBarButtonItem(customView: addButton)
//        navigationItem.rightBarButtonItem = barButton
        
        let image = reSizeImage(image: UIImage(named: "fr_add")!, reSize: CGSize(width: 30, height: 30))
        
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addFriend))
        
        self.navigationItem.rightBarButtonItem  = button
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendAllSegue" {
            friendAllVC = (segue.destination as! FriendAllVC)
        }
    }
    
    @objc func addFriend() {
        print("addFriend")
        self.navigationController?.pushViewController(showQRCodeVC, animated: true)
    }
    
    func reSizeImage(image: UIImage, reSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(reSize, false, UIScreen.main.scale);
        image.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage;
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
