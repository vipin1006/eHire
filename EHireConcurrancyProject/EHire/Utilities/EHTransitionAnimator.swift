//
//  MyTransitionAnimator.swift
//  EHire
//
//  Created by Vipin Nambiar on 22/02/16.
//  Copyright © 2016 Exilant Technologies. All rights reserved.
//


import Cocoa

class EHTransitionAnimator: NSObject , NSViewControllerPresentationAnimator {

    func animatePresentationOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
        
        if let window = fromViewController.view.window {
            NSAnimationContext.runAnimationGroup({ (context) -> Void in
                
                //                fromViewController.view.animator().alphaValue = 0
                }, completionHandler: { () -> Void in
                    //                    viewController.view.alphaValue = 0
                    window.contentViewController  = viewController
                    let slideInFromLeftTransition = CATransition()
                    slideInFromLeftTransition.delegate = self
                    slideInFromLeftTransition.type = kCATransitionPush
                    slideInFromLeftTransition.subtype = kCATransitionFromRight
                    slideInFromLeftTransition.duration = 0.4
                    slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    slideInFromLeftTransition.fillMode = kCAFillModeRemoved
                    //        appDelegate.mainWindowController?.contentViewController = feedbackViewController
                    viewController.view.wantsLayer = true
                    viewController.view.layer!.addAnimation(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
                    
//                    fromViewController.view.animator().animationForKey("slideInFromLeftTransition")
            })
        }
        
    }
    
    func animateDismissalOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
        if let window = viewController.view.window {
            NSAnimationContext.runAnimationGroup({ (context) -> Void in
                
                let slideInFromLeftTransition = CATransition()
                slideInFromLeftTransition.delegate = self
                slideInFromLeftTransition.type = kCATransitionPush
                slideInFromLeftTransition.subtype = kCATransitionFromLeft
                slideInFromLeftTransition.duration = 0.4
                slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                slideInFromLeftTransition.fillMode = kCAFillModeRemoved
                //        appDelegate.mainWindowController?.contentViewController = feedbackViewController
                viewController.view.wantsLayer = true
                viewController.view.layer!.addAnimation(slideInFromLeftTransition, forKey: "slideInFromRightTransition")
                 viewController.view.alphaValue = 0
                //                fromViewController.view.animator().alphaValue = 0
                }, completionHandler: { () -> Void in
                    
                    
                   
                    window.contentViewController  = fromViewController
                   
            })
        }
    }
}
