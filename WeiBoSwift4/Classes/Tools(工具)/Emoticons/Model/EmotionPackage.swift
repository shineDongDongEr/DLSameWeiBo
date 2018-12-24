//
//  EmotionPackage.swift
//  表情键盘demo
//
//  Created by  GAIA on 2018/10/11.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit

class EmotionPackage: NSObject {
   //MARK:- 懒加载属性
   lazy var emoticons : [Emoticon] = [Emoticon]()
    //MARK:- 构造函数
    init(id : String) {
        super.init()
        //1.最近分组
        if id == "" {
            addEmptyEmoticon(isRecently: true)
        }else{
            //2.根据id拼接info。plist路径
            let plistPath = Bundle.main.path(forResource: "\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
            //3.根据plist的路径读取数据 [[String ： String]]
            let array = NSArray.init(contentsOfFile: plistPath)! as! [[String : String]]
            //4.遍历数组
            var index = 0
            for var dict in array{
                if let png = dict["png"]{
                    dict["png"] = id + "/" + png
                }
                emoticons.append(Emoticon(dict: dict))
                index += 1
                if index == 20{
                    //表情每隔20个，添加一个删除按钮
                    emoticons.append(Emoticon(isRemove: true))
                    index = 0
                }
            }
            //5.添加空白表情
            addEmptyEmoticon(isRecently: false)
        }
        
    }
    private func addEmptyEmoticon(isRecently : Bool){
        
        let count = emoticons.count % 21
        if count == 0 && !isRecently {
            return
        }
        for _ in count..<20{
            emoticons.append(Emoticon(isRecently : true))
        }
        
        emoticons.append(Emoticon(isRemove: true))
    }
}
