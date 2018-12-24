//
//  AppDelegate.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/7/10.
//  Copyright © 2018年  GAIA. All rights reserved.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //计算属性
    var defaultViewController : UIViewController? {
        
        let isLogin = UserAccountTool.shareInstance.isLogin
        
        UIStoryboard(name: "Main",bundle: nil).instantiateInitialViewController()
        
        return isLogin ? WelcomeViewController() : UIStoryboard(name: "Main",bundle:nil).instantiateInitialViewController()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //设置全局颜色
        UITabBar.appearance().tintColor = UIColor.orange
        UINavigationBar.appearance().tintColor = UIColor.orange
        
        //创建window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = defaultViewController
        window?.makeKeyAndVisible()
        
//        print("++++++++++++\(String(describing: UserAccountTool.shareInstance.account?.access_token))")
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {
    }


}

