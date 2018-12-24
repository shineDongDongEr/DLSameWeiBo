//
//  BaseViewController.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/7/25.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {
    //MARK:- 定义变量
    var isLogin : Bool = false
    //MARK:- 懒加载数据
    lazy var visitorView = VisitorView.loadVisitorView()
    
    //MARK:- life
    override func loadView()
    {
        //1获取沙河路径
        var accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        accountPath = (accountPath as NSString).appendingPathComponent("account.plist")
        //2.读取信息
        let account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
        if let account = account {
            if let expiresDate = account.expires_date{
                isLogin = expiresDate.compare(Date()) == ComparisonResult.orderedDescending
            }
        }
        
        isLogin ? super.loadView() : setVisitorView()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupNavItems()
    

    }

}

//MARK:- UI设置
extension BaseViewController{
    //设置访客视图
    private func setVisitorView()
    {
        view = visitorView
        visitorView.registBtn.addTarget(self, action: #selector(BaseViewController.registBtnClick), for: .touchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(BaseViewController.loginBtnClick), for: .touchUpInside)

    }
    //MARK:- 设置导航栏item
    private func setupNavItems()
    {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "注册", style: .plain, target: self, action:#selector(BaseViewController.registBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "登录", style: .plain, target: self, action:#selector(BaseViewController.loginBtnClick))
    }
}

//MARK:- 时间监听
extension BaseViewController{
  @objc private func registBtnClick()
    {
        print("点击了注册按钮")
    }
   @objc private func loginBtnClick()
    {
        print("点击了登录按钮")
        let oathVc = OAuthViewController()
        let nav = UINavigationController.init(rootViewController: oathVc)
        present(nav, animated: true, completion: nil)
    }
}


