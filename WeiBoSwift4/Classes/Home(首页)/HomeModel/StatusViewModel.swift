//
//  StatusViewModel.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/8/31.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {
    //MARK:- 定义属性
    var status : Status?
    //cell高度
    var cellHeight : CGFloat = 0
    
    //MARK:- 处理后的来源属性
    var sourceText : String?           //处理来源
    var createAtText : String?         //处理创建时间
    
    //MARK:- 对用户数据处理
    var verifiedImage : UIImage?
    var vipImage : UIImage?
    
    //MARK:- 定义url
    var profileURL : NSURL?      //处理用户头像地址
    var picURLs : [NSURL] = [NSURL]()  //处理后的微博配图
    
    
    //MARK:- 自定义构造函数
    init(status: Status){
        self.status = status
        //1.对来源进行处理
        if let source = status.source,source != ""{
            //2.截取来源字符串 <a href=\"http://app.weibo.com/t/feed/6vtZb0\" rel=\"nofollow\">微博 weibo.com</a>
            let startIndex = (source as NSString).range(of: ">").location + 1
            let length = (source as NSString).range(of: "</").location - startIndex
            sourceText = (source as NSString).substring(with: NSRange(location: startIndex, length: length))
        }
        //2.处理时间
        if let createAt = status.created_at{
            createAtText = NSDate.createDateString(creatAtStr: createAt)
        }
        
        //3.处理认证
        let verifiedType = status.user?.verified_type ?? -1
        switch verifiedType {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2,3,5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        
        //4.处理会员图标
        let mbrank = status.user?.mbrank ?? 0
        
        if mbrank > 0 && mbrank <= 6{
            vipImage = UIImage(named:"common_icon_membership_level\(mbrank)")
        }
        //5.用户头像处理
        let profileurlStirng = status.user?.profile_image_url ?? ""
        profileURL = NSURL(string: profileurlStirng)
        
        //6.处理微博配图
//        print("++++++++++\(status.pic_urls)")
//        print("____________\(status.retweeted_status?.pic_urls)")
        
        let picURLDicts = (status.pic_urls!.count != 0) ? status.pic_urls : status.retweeted_status?.pic_urls

        if let picURLDicts = picURLDicts{
            for picURLDict in picURLDicts{
                guard let pictUrlString = picURLDict["thumbnail_pic"] else {
                    continue
                }
                picURLs.append(NSURL(string: pictUrlString)! as NSURL)
            }
        }
    }
}
