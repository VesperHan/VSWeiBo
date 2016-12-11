//
//  StatusViewModel.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/11.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit
//视图模型,针对某个类进行封装
//针对模型的处理,全部交给该类做,其他的模型只负责存储即可
class StatusViewModel: NSObject {

    var status : Status?
    
    // MARK:- 对数据处理的属性
    var sourceText : String?            // 处理来源
    var createAtText : String?          // 处理创建时间
    var verifiedImage : UIImage?        // 处理用户认证图标
    var vipImage : UIImage?             // 处理用户会员等级
    var profileUrl:URL?                 // 用户头像url
    
    //自定义构造函数
    init(status:Status) {
        
        //传进来赋值给自己的属性
        self.status = status
        
        //消息来源处理
        if let source = status.source, source != "" {
        
            //对来源字符串进行处理
            let startIndex = (source as NSString).range(of: ">").location + 1
            let length = (source as NSString).range(of: "</").location-startIndex
            
            //取出字符串
            sourceText = (source as NSString).substring(with: NSRange(location: startIndex, length: length))
        }
        
        //时间处理
        if let createAt = status.created_at{
            
            createAtText = Date.createDateString(createAtStr: createAt)
        }
        
        //处理认证
        let verifiedType = status.user?.verified_type ?? -1
        switch verifiedType {
        case 0:
            verifiedImage = #imageLiteral(resourceName: "avatar_vip")
        case 2,3,5:
            verifiedImage = #imageLiteral(resourceName: "avatar_enterprise_vip")
        case 220:
            verifiedImage = #imageLiteral(resourceName: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        
        //会员图标
        let mbrank = status.user?.mbrank ?? 0
        if  mbrank > 0 && mbrank <= 6 {
            
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        
        //用户头像处理
        let profileUrlString = status.user?.profile_image_url ?? ""
        profileUrl = URL(string: profileUrlString)
    }
}
