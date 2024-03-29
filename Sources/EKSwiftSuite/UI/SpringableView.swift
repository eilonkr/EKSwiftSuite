//
//  PopableView.swift
//  
//
//  Created by Eilon Krauthammer on 14/03/2021.
//

#if !os(macOS)

import UIKit

public protocol SpringableView: UIView {
    func addSpringOnTap(alphaLevel: CGFloat, scaleAmount: CGFloat, animationDuration: TimeInterval)
}

public extension UIView {
    func addSpringOnTap(alphaLevel: CGFloat = 0.5, scaleAmount: CGFloat = 0.94, animationDuration: TimeInterval = 0.15) {
        assert(self is SpringableView, "Calling `addPopOnTap()` on non-protocol member.")
        isUserInteractionEnabled = true
        let longTap = SmartPressGestureRecogizer(target: self, action: #selector(handleTap))
        longTap.args = [
            "alphaLevel"        : alphaLevel,
            "scaleAmount"       : scaleAmount,
            "animationDuration" : animationDuration
        ]
        
        addGestureRecognizer(longTap)
    }
    
    @objc private func handleTap(gesture: SmartPressGestureRecogizer) {
        let alphaLevel   = gesture.args["alphaLevel"] as! CGFloat
        let scaleAmount  = gesture.args["scaleAmount"] as! CGFloat
        let animDuration = gesture.args["animationDuration"] as! TimeInterval
        
        if gesture.state == .began {
            UIView.animate(withDuration: animDuration, delay: 0, options: .allowUserInteraction) {
                self.transform = .evenScale(scaleAmount)
                self.alpha = alphaLevel
            }
        } else if gesture.state == .ended {
            UIView.animate(withDuration: animDuration, delay: 0, options: .allowUserInteraction) {
                self.transform = .identity
                self.alpha = 1.0
            }
        }
    }
}
#endif
