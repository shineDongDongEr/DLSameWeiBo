//
//  User.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/8/30.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit

class User: NSObject {
    //MARK:- 属性
   @objc var profile_image_url : String?     //用户的头像
   @objc var screen_name : String?           //用户昵称
   @objc var verified_type : Int = -1      //用户的认证类型
   @objc var mbrank : Int = 0           //用户的会员等级

    //自定义构造函数
    init(dict : [String : AnyObject]){
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
