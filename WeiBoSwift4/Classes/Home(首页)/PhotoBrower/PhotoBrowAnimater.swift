//
//  PhotoBrowAnimater.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/12/20.
//  Copyright © 2018年  GAIA. All rights reserved.
//

import UIKit

//面向协议开发
protocol AnimatorPresentedDelegate : NSObjectProtocol {
    
    func getStartRect(indexPath : NSIndexPath) -> CGRect
    func getEndRect(indexPath : NSIndexPath) -> CGRect
    func imageView(indexPath : NSIndexPath) -> UIImageView
}

protocol AnimatorDismissDelegate : NSObjectProtocol {
    func indexPathForDismissView() -> NSIndexPath
    func imageViewForDismissView() -> UIImageView
}

class PhotoBrowAnimater: NSObject {
    //是否是弹出动画
    var isPresented : Bool = false
    
    var delegate : AnimatorPresentedDelegate?
    var dismissDelegate : AnimatorDismissDelegate?
    var indexPath : NSIndexPath?
}

extension PhotoBrowAnimater : UIViewControllerTransitioningDelegate{
    //自定义弹出动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    //自定义消失动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}

extension PhotoBrowAnimater : UIViewControllerAnimatedTransitioning
{
    //动画执行时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
     //可以获取到转场上下文，获取弹出的view和消失的view
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresented(transitionContext: transitionContext) : animationForDissmiss(transitionContext: transitionContext)
    }
    
    //自定义弹出动画
    private func animationForPresented(transitionContext: UIViewControllerContextTransitioning)
    {
        //0.nil值校验
        guard let delegate = delegate , let indexPath = indexPath else {
            return
        }
        //1.获取弹出view
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        //2.添加到containerView上
        transitionContext.containerView.addSubview(presentedView)
        //3.获取执行动画的imageView
        let startFrame = delegate.getStartRect(indexPath: indexPath)
        let imageView = delegate.imageView(indexPath: indexPath)
        transitionContext.containerView.addSubview(imageView)
        imageView.frame = startFrame
        //4.执行动画
        presentedView.alpha = 0.0
        transitionContext.containerView.backgroundColor = UIColor.black
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView.frame = delegate.getEndRect(indexPath: indexPath)
        }) { (_) in
            imageView.removeFromSuperview()
            presentedView.alpha = 1.0
            transitionContext.completeTransition(true)
        }
    }
    
    //自定义消失动画
    private func animationForDissmiss(transitionContext: UIViewControllerContextTransitioning)
    {
        //0.nil值校验
        guard let dismissDelegate = dismissDelegate , let delegate = delegate else {
            return
        }
        //1.取出消失的View
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        dismissView?.removeFromSuperview()
        
        //2.获取执行动画的ImageView
        let imageView = dismissDelegate.imageViewForDismissView()
        let indexPath = dismissDelegate.indexPathForDismissView()
        transitionContext.containerView.addSubview(imageView)
        //2.执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView.frame = delegate.getStartRect(indexPath: indexPath)
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}
