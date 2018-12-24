//
//  NavTitleBtn.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/8/1.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit

class NavTitleBtn: UIButton {
//MARK:- 重写init函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(UIImage(named:"navigationbar_arrow_down"), for: .normal)
        setImage(UIImage(named:"navigationbar_arrow_up"), for: .selected)
        setTitleColor(UIColor.black, for: .normal)
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = (titleLabel?.frame.size.width)! + 5
    }
    
}
