//
//  Status.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/8/30.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit

class Status: NSObject {
    
    //MARK:- 属性
   @objc var mid : Int = 0                 //微博ID
   @objc var text : String?                //微博正文
    
   @objc var user : User?

   @objc var created_at : String?                 //创建时间
   @objc var source : String?                     //微博来源
   @objc var pic_urls : [[String : String]]?       //微博的配图
   @objc var retweeted_status : Status? //微博对应的转发微博


    
    //自定义构造函数
    init(dict : [String : AnyObject]){
        super.init()
        setValuesForKeys(dict)
        if let userDict = dict["user"] as? [String : AnyObject]{
            user = User(dict:userDict)
        }
        if let retweeted_statusDict = dict["retweeted_status"] as? [String : AnyObject]{
            retweeted_status = Status(dict: retweeted_statusDict)
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}

}
