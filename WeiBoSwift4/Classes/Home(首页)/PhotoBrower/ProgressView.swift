//
//  ProgressView.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/12/14.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    //MARK:- 自定义属性
    var progress : CGFloat = 0{
        didSet{
            DispatchQueue.main.sync {
                setNeedsDisplay()
            }
        }
    }
    
    //MARK:- 重写drawRect方法
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //获取参数
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let radius = rect.width * 0.5 - 3
        let startAngle = CGFloat(-M_PI_2)
        let endAngle = CGFloat(2 * M_PI_2) * progress + startAngle
        
        //创建贝塞尔曲线
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        //创建一条到中心点的线
        path.addLine(to: center)
        path.close()
        
        //设置绘制的颜色
        UIColor(white: 1.0,alpha:1).setFill()
        
        
        //开始绘制
        path.fill()
    }
}
