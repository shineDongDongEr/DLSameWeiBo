//
//  UIBarButttonItem-Extension.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/8/1.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    convenience init(imageName : String)
    {
        self.init()
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: imageName + "highlighted"), for: .highlighted)
        btn.sizeToFit()
        self.customView = btn
    }
}
