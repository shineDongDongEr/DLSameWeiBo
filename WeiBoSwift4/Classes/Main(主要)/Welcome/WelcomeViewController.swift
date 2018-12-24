//
//  WelcomeViewController.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/8/28.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {
   //头像
    @IBOutlet weak var headImv: UIImageView!
   //距离底部约束
    @IBOutlet weak var headToBottomCns: NSLayoutConstraint!
    
    //MARK:- life
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        //1获取沙河路径
//        var accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//        accountPath = (accountPath as NSString).appendingPathComponent("account.plist")
//        //2.读取信息
//        let account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
        
        let account = UserAccountTool.shareInstance.account
        let headString = account?.avatar_hd
        let url = NSURL(string: headString ?? "")
        //设置头像
        headImv.sd_setImage(with: url as URL?, placeholderImage: UIImage(named:"avatar_default"), options:[], completed: nil)
        //改变约束值
        self.headToBottomCns.constant = UIScreen.main.bounds.size.height - 200
        //执行动画
        //Damping ： 阻力系数越大，弹动效果越不明显 0~1
        //initialSpringVelocity： 初始化速度
        UIView.animate(withDuration: 1.5, delay:0.0 , usingSpringWithDamping: 0.6, initialSpringVelocity: 7.0, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main",bundle:nil).instantiateInitialViewController()
        }
    }
}
