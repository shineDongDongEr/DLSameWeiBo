//
//  UserAccount.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/8/14.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit

class UserAccount: NSObject,NSCoding{

    //MARK:- 属性
    //授权的accessToken
   @objc var access_token : String?
    //过期的时间->秒
    @objc var expires_in : TimeInterval = 0.0{
        //监听赋值
        didSet {
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
        
    }
    //过期日期
   @objc var expires_date : NSDate?
    
    //用户id
   @objc var uid : String?
    
    //头像图片
   @objc var avatar_hd : String?
    //昵称
    @objc var screen_name : String?

    //自定义构造函数
    init(dict : [String : AnyObject]){
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    //重写description的属性
    override var description: String{
        //重写打印格式
        return dictionaryWithValues(forKeys: ["screen_name","avatar_hd","access_token","expires_date","uid"]).description
    }
    //MARK:- 归档&解档
    //归档方法
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(avatar_hd, forKey: "avatar_hd")
        aCoder.encode(screen_name, forKey: "screen_name")
    }
    //解档方法
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? NSDate
        avatar_hd = aDecoder.decodeObject(forKey: "avatar_hd") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
        
    }
    
}
