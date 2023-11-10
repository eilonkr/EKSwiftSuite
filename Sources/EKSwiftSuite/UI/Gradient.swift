//
//  Gradient.swift
//  
//
//  Created by Eilon Krauthammer on 17/01/2021.
//

#if !os(macOS)

import UIKit

public struct Gradient: Equatable {
    public var direction: Direction
    public var colors: [UIColor]
    public var locations: [NSNumber]?
    
    public init(direction: Gradient.Direction, colors: [UIColor], locations: [NSNumber]? = nil) {
        self.direction = direction
        self.colors = colors
        self.locations = locations
    }
    
    public static func solid(_ color: UIColor) -> Gradient {
        Gradient(direction: .horizontal, colors: [color])
    }
    
    public static func fade(direction: Gradient.Direction, startColor: UIColor) -> Gradient {
        Gradient(direction: direction, colors: [
            startColor,
            startColor.withAlphaComponent(0.0)
        ])
    }
}

public extension Gradient {
    enum Direction: Equatable {
        public static func == (lhs: Gradient.Direction, rhs: Gradient.Direction) -> Bool {
            switch (lhs, rhs) {
                case (.vertical, .vertical):
                    return true
                case (.horizontal, .horizontal):
                    return true
                case (.diagonalLTR, .diagonalLTR):
                    return true
                case (diagonalRTL, .diagonalRTL):
                    return true
                case (.custom(let p1), .custom(let p2)):
                    return p1 == p2
                default:
                    return false
            }
        }
        
        case vertical, horizontal, diagonalLTR, diagonalRTL
        case custom((CGPoint, CGPoint))
        
        public var points: (start: CGPoint, end: CGPoint) {
            switch self {
                case .vertical:
                    return (CGPoint(x: 0.5, y: 0.0), CGPoint(x: 0.5, y: 1.0))
                case .horizontal:
                    return (CGPoint(x: 0.0, y: 0.5), CGPoint(x: 1.0, y: 0.5))
                case .diagonalLTR:
                    return (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0))
                case .diagonalRTL:
                    return (CGPoint(x: 1.0, y: 0.0), CGPoint(x: 0.0, y: 1.0))
                case .custom(let points):
                    return (points.0, points.1)
            }
        }
    }
}

#endif
