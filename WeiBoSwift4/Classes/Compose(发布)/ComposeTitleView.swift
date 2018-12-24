//
//  ComposeTitleView.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/9/27.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTitleView: UIView {
    
//MARK:- lazyLoading
private lazy var titleLabel = UILabel()
private lazy var screenNameLabel = UILabel()
    //MARK:- 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ComposeTitleView{
    
    private func setupUI(){
        //1.将子控件添加到View中
        addSubview(titleLabel)
        addSubview(screenNameLabel)
        
        //2.设置frame(sanpKit布局)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(-20)
        }
        screenNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        //3.设置属性
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        screenNameLabel.font = UIFont.systemFont(ofSize: 14)
        screenNameLabel.textColor = UIColor.lightGray
        
        //4.设置文字内容
        titleLabel.text = "发微博"
        screenNameLabel.text = UserAccountTool.shareInstance.account?.screen_name
        
    }
    
}
