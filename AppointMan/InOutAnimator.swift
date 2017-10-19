//
//  InOutAnimator.swift
//  AppointMan
//
//  Created by Gianluigi Pelle on 10/19/17.
//  Copyright © 2017 Scratch App. All rights reserved.
//

import UIKit

class InOutAnimator: NSObject, UIViewControllerAnimatedTransitioning {
   
   var duration: Double = 2.0
   var originFrame: CGRect = CGRect.zero
   var presentingVCFrame: CGRect = CGRect.zero
   var isPresenting: Bool = true
   
   func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
      return self.duration
   }
   
   func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
      
      let containerView = transitionContext.containerView
      let fromVC = transitionContext.view(forKey: .from)!
      let toVC = transitionContext.view(forKey: .to)!
      
      if self.isPresenting {
         toVC.transform = CGAffineTransform(scaleX: self.originFrame.size.width / UIScreen.main.bounds.size.width, y: self.originFrame.size.height / UIScreen.main.bounds.size.height)
         toVC.frame = self.originFrame
         containerView.addSubview(toVC)
         
         UIView.animate(withDuration: self.duration, animations: {
            toVC.transform = .identity
            toVC.frame = UIScreen.main.bounds
         }, completion: { _ in
            transitionContext.completeTransition(true)
         })
      } else {
         toVC.frame = self.presentingVCFrame
         containerView.addSubview(toVC)
         UIView.animate(withDuration: self.duration, animations: {
            fromVC.alpha = 0.0
         }, completion: { _ in
            transitionContext.completeTransition(true)
         })
      }
   }
}
