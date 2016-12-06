//
//  VisitorView.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/5.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class VisitorView: UIView {

// MARK:- 提供快速创建的类方法
    class func visitorView()-> VisitorView{
        // as! VisitorView 确定有这个文件,可以强制解析
        
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)?.first! as! VisitorView
    }
    
    // MARK:- 控件属性
    
    @IBOutlet weak var rotationView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    // MARK:- 自定义函数
    func setupVisitorViewInfo(icon:UIImage,title:String){
    
        iconView.image = icon
        rotationView.isHidden = true
        tipLabel.text = title
    }
    
    func addRotationAnim() {
        
        if rotationView.isHidden == true {
            return
        }
//        1.创建旋转动画
//        CAKeyframeAnimation           CABasicAnimation
//        从什么位置开始转 到哪结束
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        //动画属性
        rotationAnim.fromValue = 0
        rotationAnim.toValue = M_PI*2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 5
        //核心动画的问题是,从后台又回来,或者从其他页面回来动画会消失,以下代码不许消失,把所有属性都设置好再添加到图层中
        rotationAnim.isRemovedOnCompletion = false
        //添加到图层中
        rotationView.layer.add(rotationAnim, forKey: nil)
    }
}

