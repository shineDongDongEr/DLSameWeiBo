//
//  UserAccountTool.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/8/27.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit

class UserAccountTool {
    //MARK:- 将类设计成单例
    static let shareInstance : UserAccountTool = UserAccountTool()
    
    //MARK:- 定义属性记录
    var account : UserAccount?
    
    //MARK:- 计算属性
    var accountPath : String{
        let accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return (accountPath as NSString).appendingPathComponent("account.plist")
    }
    var isLogin : Bool {
        if account == nil {
            return false
        }
        guard let expiresDate = account?.expires_date else {
            return false
        }
        return expiresDate.compare(Date()) == ComparisonResult.orderedDescending
    }
    
    //MARK:- 重写init（）函数
    init() {
        //1.从沙河中读取归档信息
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
    }

}
