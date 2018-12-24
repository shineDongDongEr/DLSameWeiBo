//
//  PopoverAnimator.swift
//  WeiBoSwift4
//
//  Created by  GAIA on 2018/8/2.
//  Copyright © 2018年  GAIA. All rights reserved.

import UIKit

class PopoverAnimator: NSObject {
    //是否是弹出动画
    var isPresented : Bool = false
    //提供对外frame属性
    var presentFrame : CGRect = CGRect.zero
    //逆传
    var callBack : ((_ isPresent : Bool) -> ())?
    override init() {}
    //MARK:- 自定义构造函数
    //自定义构造函数，如果没有对父类的 构造函数init（）进行重写，那么自定义的构造函数会覆盖默认的
    init(callBack : ((_ isPresent : Bool) -> ())?)
    {
        self.callBack = callBack
    }
}
//MARK:- 自定义转场代理的方法
extension PopoverAnimator : UIViewControllerTransitioningDelegate
{
    //目的：修改containerView的尺寸大小
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?
    {
        let presentation = GAPresentationController(presentedViewController: presented, presenting: presenting)
        presentation.presentedFrame = presentFrame
        return presentation
    }
    //目的：自定义弹出动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        callBack!(isPresented)
        return self
    }
    //目的：自定义消失动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        callBack!(isPresented)
        return self
    }
}

//MARK:- UIViewControllerAnimatedTransitioning
extension PopoverAnimator:UIViewControllerAnimatedTransitioning
{
    //动画执行时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    //可以获取到转场上下文，获取弹出的view和消失的view
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresented(transitionContext: transitionContext) : animationForDismiss(transitionContext: transitionContext)
    }
    //自定义弹出动画
    private func animationForPresented(transitionContext: UIViewControllerContextTransitioning)
    {
        //1.获取弹出的View
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        //2.将弹出的View添加到containerView中
        transitionContext.containerView.addSubview(presentedView)
        //3.执行动画
        presentedView.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.0)
        //uiview的默认锚点是（0.5，0.5），这里必须重新设置下锚点
        presentedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            presentedView.transform = CGAffineTransform.identity
        }) { (isFinish : Bool) in
            //必须告诉转场上下文，动画已经完成
            transitionContext.completeTransition(true)
        }
    }
    //自定义消失动画
    private func animationForDismiss(transitionContext: UIViewControllerContextTransitioning)
    {
        //1.获取消失的View
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dismissView.transform = CGAffineTransform.init(scaleX: 1, y: 0.000001)
        }) { (isFinish : Bool) in
            dismissView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
 }
    
    
}
