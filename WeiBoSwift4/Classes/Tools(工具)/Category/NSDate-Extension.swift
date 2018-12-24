//
//  NSDate-Extension.swift
//  swift微博事件处理demo
//
//  Created by  GAIA on 2018/8/30.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import Foundation

extension NSDate{
    class func createDateString(creatAtStr : String) -> String{
        //1.创建时间格式化对象
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.locale = NSLocale(localeIdentifier: "en") as Locale!
        
        //2.将字符串时间转化成NSDate类型
        guard let creatDate = fmt.date(from: creatAtStr) else {
            return ""
        }
        //3.创建当前时间
        let nowDate = Date()
        
        //4.计算创建时间和当前时间的时间差
        let interval = Int(nowDate.timeIntervalSince(creatDate))
        
        //5.对时间间隔进行处理
        //5.1 显示“刚刚”
        if interval < 60 {
            return "刚刚"
        }
        //5.2 10分钟前
        if interval < 60 * 60 {
            return "\(interval / 60)分钟前"
        }
        
        //5.3 "11小时前"
        if interval < 60 * 60 * 24{
            
            return "\(interval / (60 * 60))小时前"
        }
        
        //5.4 创建日历对象
        let calender = NSCalendar.current
        
        //5.5 处理昨天数据
        if calender.isDateInYesterday(creatDate){
            fmt.dateFormat = "昨天 HH:mm"
            let timeStr = fmt.string(from: creatDate)
            return timeStr
        }
        
        //5.6 处理一年之内 ： 02-22 12：22
        let cmps = calender.component(.year, from: creatDate)
        if cmps < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            let timeStr = fmt.string(from: creatDate)
            return timeStr
        }
        
        //5.7超过一年 ： 2011-08-25
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        let timeStr = fmt.string(from: creatDate)
        return timeStr
    }
}
