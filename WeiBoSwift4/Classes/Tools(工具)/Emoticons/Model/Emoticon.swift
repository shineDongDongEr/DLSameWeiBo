//
//  Emoticon.swift
//  表情键盘demo
//
//  Created by  GAIA on 2018/10/11.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit

class Emoticon: NSObject {
    //MARK:- 定义属性
    //是否是删除按钮
    var isRemove : Bool = false
    //是否是最近的模块
    var isRecently : Bool = false
   @objc var code : String? //emoji的code
    {
        didSet{
            guard let code = code else {
                return
            }
            //emoji字符串转化都是固定的写法！！！
            
            //1.创建一个扫描器
            let scanner = Scanner(string: code)

            //2.调用方法，扫描出code中的值
            var value : UInt32 = 0
            scanner.scanHexInt32(&value)
            //3.将value转成字符
            let c = Character(UnicodeScalar(value)!)
            
            //4.将字符转成字符串
            emojiCode = String(c)
        }
    }
     @objc  var png : String?  //普通表情对应的图片名称
    {
        didSet {
            //1.nil值校验
            guard let png = png else{return}
            //2.拼接绝对路径
            pngPath = Bundle.main.bundlePath + "/Emoticons.bundle/" + png
        }
    }
   @objc var chs : String?  //普通表情对应的文字
    
    //MARK:- 数据处理
      @objc  var pngPath : String?
      @objc  var emojiCode : String?
    
    //MARK:- 自定义构造函数
    init(isRemove : Bool) {
        super.init()
        self.isRemove = isRemove
    }
    init(isRecently : Bool) {
       super.init()
        self.isRecently = isRecently
        
    }
    init(dict : [String : String]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var description: String{

        return dictionaryWithValues(forKeys:["pngPath","emojiCode","chs"]).description
    }
    
    
}
