//
//  Animation.swift
//  
//
//  Created by Eilon Krauthammer on 29/03/2021.
//

import UIKit

public struct Animation {
    let duration: TimeInterval
    let closure: (UIView) -> Void
}

public extension Animation {
    static func fadeIn(duration: TimeInterval) -> Animation {
        return Animation(duration: duration) { view in
            view.alpha = 1.0
        }
    }
    
    static func fadeOut(duration: TimeInterval) -> Animation {
        return Animation(duration: duration) { view in
            view.alpha = 0.0
        }
    }
    
    static func scale(to transform: CGAffineTransform, duration: TimeInterval) -> Animation {
        return Animation(duration: duration) { view in
            view.transform = transform
        }
    }
    
    static func translated(by transform: CGAffineTransform, duration: TimeInterval) -> Animation {
        return Animation(duration: duration) { view in
            view.transform = view.transform.translatedBy(x: transform.tx, y: transform.ty)
        }
    }
    
    static func moveOrigin(to point: CGPoint, duration: TimeInterval) -> Animation {
        return Animation(duration: duration) { view in
            view.frame.origin = point
        }
    }
    
    static func moveCenter(to point: CGPoint, duration: TimeInterval) -> Animation {
        return Animation(duration: duration) { view in
            view.center = point
        }
    }
    
    static func changeFrame(to rect: CGRect, duration: TimeInterval) -> Animation {
        return Animation(duration: duration) { view in
            view.frame = rect
        }
    }
}
