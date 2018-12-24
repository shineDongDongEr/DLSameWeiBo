//
//  GAPresentationController.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/8/1.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit

class GAPresentationController: UIPresentationController {
    //MARK:- lazyLoading
    private lazy var coverView = UIView()
    //MARK:- 对外提供属性
    var presentedFrame : CGRect = CGRect.zero
    
    //MARK:- 系统回调函数
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        //1.设置尺寸
        presentedView?.frame = presentedFrame
        //2.添加蒙版
        setCover()
    }
}

extension GAPresentationController{
   private func setCover(){
    //添加蒙版
        containerView?.insertSubview(coverView, at: 0)
    
        coverView.backgroundColor = UIColor(white: 0.2 , alpha: 0.6)
        coverView.frame = containerView!.bounds
    
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(GAPresentationController.tapCover))
        coverView.addGestureRecognizer(tap)
    }
}

//MARK:- 手势监听
extension GAPresentationController{
   @objc private func tapCover(){
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

