//
//  MessageViewController.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/7/11.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit

class MessageViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        visitorView.setupVisitorViewInfo(iconName: "visitordiscover_image_message", title: "登录后，别人评论你的微博，给你发消息，都会在这里收到通知")
    }

}
