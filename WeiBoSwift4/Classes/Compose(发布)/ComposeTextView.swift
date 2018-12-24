//
//  ComposeTextView.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/9/27.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit

class ComposeTextView: UITextView {

    //MARK:- lazyLoading
    lazy var placeHolderLabel : UILabel = UILabel()
    //MARK:- 构造函数
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
}

//MARK:- 设置UI界面
extension ComposeTextView{
    
    private func setupUI(){
        addSubview(placeHolderLabel)
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(10)
        }
        placeHolderLabel.textColor = UIColor.lightGray
        placeHolderLabel.font = font
        placeHolderLabel.text = "分享新鲜事..."
        
        textContainerInset = UIEdgeInsetsMake(6, 7, 0, 7)
        
    }
}



