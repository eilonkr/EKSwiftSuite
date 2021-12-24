//
//  UIViewController+Extensions.swift
//  
//
//  Created by Eilon Krauthammer on 05/06/2021.
//

#if !os(macOS)

import UIKit

public extension UIViewController {
    func addAsChildTo(parentVc: UIViewController, inside container: UIView, offset: CGPoint = .zero) {
        parentVc.addChild(self)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(self.view)
        
        view.bindFrameToSuperviewBounds(offset: offset)
        didMove(toParent: parentVc)
    }
    
    func removeChildViewController() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func addAsSafeAreaChildTo(parentVc: UIViewController, inside container: UIView) {
          parentVc.addChild(self)
          self.view.translatesAutoresizingMaskIntoConstraints = false
          container.addSubview(self.view)
          
          view.bindMarginsToSuperviewWithBottomSafeArea()
          didMove(toParent: parentVc)
    }
}
#endif
