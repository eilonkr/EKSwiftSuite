//
//  CornerRadiusStyle.swift
//  
//
//  Created by Eilon Krauthammer on 14/03/2021.
//

import UIKit

public enum CornerRadiusStyle: Equatable {
    public enum Masking {
        case topHorizontal
        case bottomHorizontal
        case rightVertical
        case leftVertical
        case leftToRightDiagonal
        case rightToLeftDiagnonal
        case custom(CACornerMask)
    }
    
    public static func == (lhs: CornerRadiusStyle, rhs: CornerRadiusStyle) -> Bool {
        switch (lhs, rhs) {
            case (.rounded, .rounded):
                return true
            case (.custom(let a), .custom(let b)):
                return a == b
            case (.other(let v1), .other(let v2)):
                return v1 === v2
            default:
                return false
        }
    }
    
    case rounded
    case custom(CGFloat)
    case other(UIView)
}
