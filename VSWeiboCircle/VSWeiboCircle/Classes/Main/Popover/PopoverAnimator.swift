//
//  PopoverAnimator.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/7.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject {

    var isPresented : Bool = false
    
    var presentedFrame = CGRect.zero

    var stateCallBack :((_ present:Bool)->())?
    
    // MARK:- 自定义构造函数
    // 如果自定义一个构造函数,没有对父类的构造函数进行重写,那么自定义的构造函数会覆盖父类
    // noescape 只不允许逃逸出这个函数,只能在该函数内执行
    init(stateCallBack :@escaping (_ present:Bool)->()) {

        self.stateCallBack = stateCallBack
    }
    
}

extension PopoverAnimator :UIViewControllerTransitioningDelegate {

    //transition delegate
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return VSPresentController(presentedViewController: presented, presenting: presenting)
    }

    //目的 - 自定义弹出动画 animated delegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = true
        
        stateCallBack!(isPresented)
        
        return self
    }
    
    //目的 - 消失动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = false
        
        stateCallBack!(isPresented)
        return self
    }
}

extension PopoverAnimator:UIViewControllerAnimatedTransitioning{
    
    
    //自定义弹出动画时间  必须实现
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    /// 获取`转场的上下文`:可以通过转场上下文获取弹出的View和消失的View
    // UITransitionContextFromViewKey : 获取消失的View
    // UITransitionContextToViewKey : 获取弹出的View
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(transitionContext: transitionContext) : animationForDismissedView(transitionContext: transitionContext)
    }
    
    /// 自定义弹出动画
    private func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        // 1.获取弹出的View
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        // 2.将弹出的View添加到containerView中
        transitionContext.containerView.addSubview(presentedView)
        
        // 3.执行动画
        presentedView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
        presentedView.layer.anchorPoint = CGPoint(x:0.5, y:0)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            presentedView.transform = CGAffineTransform.identity
        }) { (_) -> Void in
            // 必须告诉转场上下文你已经完成动画
            transitionContext.completeTransition(true)
        }
    }
    
    /// 自定义消失动画
    private func animationForDismissedView(transitionContext: UIViewControllerContextTransitioning) {
        // 1.获取消失的View
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        
        // 2.执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            dismissView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.0001)
        }) { (_) -> Void in
            dismissView?.removeFromSuperview()
            // 必须告诉转场上下文你已经完成动画
            transitionContext.completeTransition(true)
        }
    }
}
