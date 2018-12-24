//
//  EmotionManager.swift
//  表情键盘demo
//
//  Created by  GAIA on 2018/10/11.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit

class EmotionManager {
    
   lazy var packages : [EmotionPackage] = [EmotionPackage]()
    
    init() {
        
        //1.添加最近的表情包
        packages.append(EmotionPackage.init(id: ""))
         //2.添加默认的表情包
        packages.append(EmotionPackage.init(id : "com.sina.default"))
         //3.添加emoji的表情包
        packages.append(EmotionPackage.init(id : "com.apple.emoji"))
         //4.添加浪小花的表情包
        packages.append(EmotionPackage.init(id : "com.sina.lxh"))

    }
    

}
