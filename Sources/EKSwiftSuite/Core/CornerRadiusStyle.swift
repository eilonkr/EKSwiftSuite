//
//  CornerRadiusStyle.swift
//  
//
//  Created by Eilon Krauthammer on 14/03/2021.
//

import UIKit

public enum CornerRadiusStyle: Equatable {
    public static func == (lhs: CornerRadiusStyle, rhs: CornerRadiusStyle) -> Bool {
        switch (lhs, rhs) {
            case (.rounded, .rounded):
                return true
            case (.custom(let a), .custom(let b)):
                return a == b
            default:
                return false
        }
    }
    
    case rounded
    case custom(CGFloat)
    case other(UIView)
}
