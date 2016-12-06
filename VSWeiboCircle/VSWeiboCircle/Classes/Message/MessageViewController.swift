//
//  MessageViewController.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/2.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class MessageViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

     visitorView.setupVisitorViewInfo(icon: #imageLiteral(resourceName: "visitordiscover_image_message"), title: "消息")
    }
}
