//
//  ProfileViewController.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/7/11.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        visitorView.setupVisitorViewInfo(iconName: "visitordiscover_image_profile", title: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")

    }

}
