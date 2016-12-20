//
//  ProgressView.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/19.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    var pregress: CGFloat = 0{
    
        didSet{
            
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        //获取参数
        
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let redius = rect.width * 0.5 - 3
        let startAngle = CGFloat(-M_PI_2)
        let endAngle = CGFloat(2 * M_PI) * pregress + startAngle
        
        let path = UIBezierPath(arcCenter: center, radius: redius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        //绘制一条中心点的线
        path.addLine(to: center)
        path.close()
        
        //设置绘制颜色
        UIColor.orange.setFill()
        
        //开始绘制
        path.fill()
    }
}
