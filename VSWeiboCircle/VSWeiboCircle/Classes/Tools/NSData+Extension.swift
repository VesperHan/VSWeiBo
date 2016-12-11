//
//  NSData+Extension.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/11.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import Foundation

extension Date {

    
    //为什么不用遍历构造函数
    //因为返回的是字符串不是Date类型
    static func createDateString(createAtStr : String) -> String{
        
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
    
        guard let createDate = fmt.date(from: createAtStr) else {
            
            return ""
        }
        
        let nowDate = Date()
        
        //时间差
        let interval = Int(nowDate.timeIntervalSince(createDate))
        
        if interval < 60{
        
            return "刚刚"
        }
        
        if interval < 60*60{
        
            return "\(interval/(60))分钟前"
        }
        
        // 5.3.11小时前
        if interval < 60 * 60 * 24 {
            return "\(interval / (60 * 60))小时前"
        }
        
        //对隔天的判断,用到日历对象
        let calendar = Calendar.current
        
        if calendar.isDateInYesterday(createDate){
            
            fmt.dateFormat = "昨天 HH:mm"
            let timeStr = fmt.string(from: createDate)
            
            return timeStr
        }

        //一年之内的处理  枚举:一年  从创建时间到现在
        let cmps = calendar.dateComponents([.year], from: createDate, to: nowDate)
        
        if cmps.year! < 1{
        
            fmt.dateFormat = "MM-dd HH:mm"
            let timeStr = fmt.string(from: createDate)
            return timeStr
        }
        
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        let timeStr = fmt.string(from: createDate)
        
        return timeStr
    }
}
