//
//  PhotoBrowserAnimator.swift
//  VSWeiboCircle
//
//  Created by Vesperlynd on 2016/12/20.
//  Copyright © 2016年 Vesperlynd. All rights reserved.
//

import UIKit

protocol AnimatorPresentedDelegate : NSObjectProtocol {
    
    func startRect(indexPath:IndexPath)-> CGRect
    func endRect(indexPath:IndexPath)-> CGRect
    func imageView(indexPath:IndexPath)-> UIImageView
}

protocol AnimatorDismissDelegate : NSObjectProtocol {
    func indexPathForDimissView() -> IndexPath
    func imageViewForDimissView() -> UIImageView
}

class PhotoBrowserAnimator: NSObject {

    var isPresented:Bool = false
    var presentDelegate : AnimatorPresentedDelegate?
    var dismissDelegate : AnimatorDismissDelegate?
    var indexPath : IndexPath?
    
}

extension PhotoBrowserAnimator:UIViewControllerTransitioningDelegate{

//    无需实现该方法,之前实现该方法是为了改变弹出控制器的大小,而图片浏览器和屏幕尺寸一样,则无需实现
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        
//    }
    
    //我们现在需要自定义 弹出动画 和 消失动画的样式  告诉系统要自定义这两个动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = false
        return self
    }
}

// 动画的具体实现
extension PhotoBrowserAnimator : UIViewControllerAnimatedTransitioning{

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
     
        transitionContext.containerView.backgroundColor = UIColor.black

        isPresented ? animationForPresentedView(transitionContext: transitionContext) : animationForDismissView(transitionContext: transitionContext)
    }
    
    func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
     
        guard let presentDelegate = presentDelegate,let indexPath = indexPath else {
            return
        }
        
        let presentView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        transitionContext.containerView.addSubview(presentView)
        
        //获取执行动画的image
        let startRect = presentDelegate.startRect(indexPath: indexPath)
        let imageView = presentDelegate.imageView(indexPath: indexPath)
        transitionContext.containerView.addSubview(imageView)
        imageView.frame = startRect
        
        presentView.alpha = 0.0

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            imageView.frame = presentDelegate.endRect(indexPath: indexPath)
        }) { (_) in
            
            presentView.alpha = 1.0
            imageView.removeFromSuperview()
            transitionContext.containerView.backgroundColor = UIColor.clear
            transitionContext.completeTransition(true)
        }
    }
    
    func animationForDismissView(transitionContext: UIViewControllerContextTransitioning){

        guard let dismissDelegate = dismissDelegate, let presentDelegate = presentDelegate else {
            return
        }

        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        dismissView.removeFromSuperview()

        let imageView = dismissDelegate.imageViewForDimissView()
        transitionContext.containerView.addSubview(imageView)
        let indexPath = dismissDelegate.indexPathForDimissView()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            imageView.frame = presentDelegate.startRect(indexPath: indexPath)
        }) { (_) in
            
            transitionContext.containerView.backgroundColor = UIColor.clear
            transitionContext.completeTransition(true)
        }
    }
}


