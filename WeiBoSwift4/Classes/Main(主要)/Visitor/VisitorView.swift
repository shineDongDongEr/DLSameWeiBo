//
//  VisitorView.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/7/25.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit

class VisitorView: UIView {
    //MARK:- 提供xib快速创建方法
    class func loadVisitorView() -> VisitorView{
//        return Bundle.mainBundle().loadNibNamed("VisitorView", owner: nil, options:nil).first
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)?.first as! VisitorView
    }

    @IBOutlet weak var rotationImv: UIImageView!
    @IBOutlet weak var iconImv: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var registBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    //对外提供一些自定义函数
    func setupVisitorViewInfo(iconName : String , title : String){
        iconImv.image = UIImage(named:iconName)
        textLabel.text = title
        rotationImv.isHidden = true
    }
    //MARK:- 设置动画
    func setRotationAnimate(){
        //1.创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        //2.设置属性
        rotationAnim.fromValue = 0
        rotationAnim.toValue = Double.pi * 2
        rotationAnim.duration = 5
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.fillMode = kCAFillModeForwards
        rotationAnim.isRemovedOnCompletion = false
        //3.添加动画
        rotationImv.layer.add(rotationAnim, forKey: nil)
    }
    
}
