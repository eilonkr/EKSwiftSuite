//
//  UIView+Animation.swift
//  
//
//  Created by Eilon Krauthammer on 29/03/2021.
//

import UIKit

public extension UIView {
    func animateInOrder(_ animations: [Animation]) {
        guard !animations.isEmpty else { return }
        
        var animations = animations
        let animation = animations.removeFirst()
        
        UIView.animate(withDuration: animation.duration) {
            animation.closure(self)
        } completion: { _ in
            self.animateInOrder(animations)
        }
    }
    
    /// This function will use the longest animation duration in the set unless the `duration` parameter is specified.
    func animateInParallel(_ animations: [Animation], duration: TimeInterval? = nil) {
        let maxDuration = (animations.max { $0.duration > $1.duration })?.duration
        let duration = duration ?? (maxDuration ?? 0.0)
        UIView.animate(withDuration: duration) {
            for animation in animations {
                animation.closure(self)
            }
        }
    }
}

// ––––– Usage Example –––––

extension UIView {
    func animateBackAndForthToDisappear() {
        animateInOrder([
            .scale(to: .evenScale(1.2), duration: 0.1),
            .scale(to: .evenScale(0.8), duration: 0.1),
            .scale(to: .identity, duration: 1.0),
            .fadeOut(duration: 2.0)
        ])
    }
}
