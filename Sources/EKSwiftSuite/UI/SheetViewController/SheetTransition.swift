//
//  SheetTransition.swift
//  Quoti
//
//  Created by Eilon Krauthammer on 17/03/2021.
//

import UIKit

open class SheetTransition: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    private var isPresent = false
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.225
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            animatePresentTransition(transitionContext: transitionContext)
        } else {
            animateDissmissalTransition(transitionContext: transitionContext)
        }
    }
    
    func animatePresentTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let from = transitionContext.viewController(forKey: .from) ,
              let to = transitionContext.viewController(forKey: .to) as? SheetViewController  else {
            return
        }
        
        from.view.layoutIfNeeded()
        to.view.layoutIfNeeded()
        to.contentView.layoutIfNeeded()
        to.contentContainerView.layoutIfNeeded()
        to.view.backgroundColor = to.appearance.backgroundDimColor.withAlphaComponent(0.0)

        let containerView = transitionContext.containerView
        containerView.insertSubview(to.view, belowSubview: from.view)
        to.view.backgroundColor = .clear
        to.view.alpha = 1
        
        let height = to.contentContainerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        to.contentContainerView.transform = .init(translationX: 0, y: height)

        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            to.contentContainerView.transform = .identity
            to.view.backgroundColor = to.appearance.backgroundDimColor.withAlphaComponent(to.appearance.backgroundDimLevel)
            to.view.layoutIfNeeded()
            from.view.layoutIfNeeded()
        }, completion: {
            finished in
            transitionContext.completeTransition(true)
        })

    }
    
    func animateDissmissalTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let from = transitionContext.viewController(forKey: .from) as? SheetViewController,
            let to = transitionContext.viewController(forKey: .to) else {
                return
        }
        
        let containerView = from.contentContainerView
        from.view.layoutIfNeeded()
        to.view.layoutIfNeeded()
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            from.view.backgroundColor = from.appearance.backgroundDimColor.withAlphaComponent(0)
            from.view.backgroundColor = .clear
            containerView.transform = .init(translationX: 0, y: containerView.frame.height)
            from.view.layoutIfNeeded()
            to.view.layoutIfNeeded()
            
            
        }, completion: {
            finished in
            transitionContext.completeTransition(true)
        })
    }
    
}
