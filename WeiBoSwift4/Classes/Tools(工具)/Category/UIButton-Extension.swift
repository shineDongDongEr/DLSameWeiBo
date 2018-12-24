//
//  UIButton-Extension.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/7/12.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit

extension UIButton{
    
//swift中类方法是以class开头的，类似于oc中的“+”
//    class func createButton(imageName : String , bgImageName : String) -> UIButton{
//        let btn = UIButton()
//        btn.setImage(UIImage(named:imageName), for: .normal)
//        btn.setImage(UIImage(named:imageName + "_highlighted"), for: .highlighted)
//        btn.setBackgroundImage(UIImage(named:bgImageName), for: .normal)
//        btn.setBackgroundImage(UIImage(named:bgImageName +  "_highlighted"), for: .highlighted)
//        btn.sizeToFit()
//        return btn
//    }
    //自定义构造函数（swift中构造函数不需要写返回值，系统会自动返回）
    //遍历构造函数通常用在对系统的类进行构造函数的扩充时使用(oc里面不可以)
    /*
     1.遍历构造函数通常都是写在extension里面
     2.遍历构造函数init前面需要加载convernience
     3.遍历构造函数必须调用self.init
     */
    
    convenience init(imageName : String , bgImageName : String) {
        self.init()
        setImage(UIImage(named:imageName), for: .normal)
        setImage(UIImage(named:imageName + "_highlighted"), for: .highlighted)
        setBackgroundImage(UIImage(named:bgImageName), for: .normal)
        setBackgroundImage(UIImage(named:bgImageName +  "_highlighted"), for: .highlighted)
        sizeToFit()
    }
    convenience init(backColor : UIColor , textFont : CGFloat , title : String){
        self.init()
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: textFont)
        titleLabel?.textColor = UIColor.white
        backgroundColor = backColor
        
    }
}
