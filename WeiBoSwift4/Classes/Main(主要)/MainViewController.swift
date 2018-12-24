//
//  MainViewController.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/7/11.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController
{

//MARK:- 懒加载高亮图片
    private  lazy var imageNames = ["tabbar_home" , "tabbar_message_center" , "" ,"tabbar_discover" , "tabbar_profile"]
    //swift中的类方法
//    private lazy var composeBtn : UIButton = UIButton.createButton(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
    //遍历构造函数
    private lazy var composeBtn : UIButton = UIButton(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")

    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupComposeBtn()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        setupTabbarItems()
    }
}

// MARK:- 设置UI界面
extension MainViewController
{
   
    func setupComposeBtn()
    {
        tabBar.addSubview(composeBtn)

        composeBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
        
        //添加按钮点击事件/""
//        composeBtn.addTarget(self, action:Selector,"composeBtnClick", for: .touchUpInside)
        composeBtn.addTarget(self, action: #selector(MainViewController.composeBtnClick), for: .touchUpInside)
    }
    
    func setupTabbarItems()
    {
        //1.通过遍历拿到tabarItem
        for i in 0..<tabBar.items!.count
        {
            //2.获取item
            let item = tabBar.items![i]
            //3.如果下标值为2，则不可以响应点击
            if i == 2
            {
                item.isEnabled = false
                continue
            }
            //4.设置选中的图片
            item.selectedImage = UIImage(named: imageNames[i] + "_highlighted")
        }
    }
}

// MARK:- 事件监听
extension MainViewController
{
    //事件监听的本质是发送消息，发送消息是OC特性
    //把方法包装成@SEL -> 类中查找方法列表 -> 根据@SEL查找IMP（函数指针） -> 执行函数
    //如果不加@objc那么函数不会被添加到方法列表中
   @objc private func composeBtnClick() {
        print("composeBtnClick")
        let composeBtnVc = ComposeBtnViewController()
        let composeNav = UINavigationController.init(rootViewController: composeBtnVc)
        self.present(composeNav, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
}
