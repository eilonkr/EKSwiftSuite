//
//  Gradient.swift
//  
//
//  Created by Eilon Krauthammer on 17/01/2021.
//

#if !os(macOS)

import UIKit

public struct Gradient: Equatable, Decodable {
    public var direction: Direction
    public var colors: [UIColor]
    public var locations: [NSNumber]?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        direction = try container.decode(Direction.self, forKey: .direction)
        
        let colorStrings = try container.decode([String].self, forKey: .colors)
        colors = colorStrings.map { UIColor(hex: $0) }
        
        locations = nil
    }
    
    public init(direction: Direction, colors: [UIColor], locations: [NSNumber]? = nil) {
        self.direction = direction
        self.colors = colors
        self.locations = locations
    }
    
    public static func solid(_ color: UIColor) -> Gradient {
        Gradient(direction: .horizontal, colors: [color])
    }
    
    public static func fade(direction: Direction, startColor: UIColor) -> Gradient {
        Gradient(direction: direction, colors: [
            startColor,
            startColor.withAlphaComponent(0.0)
        ])
    }
    
    private enum CodingKeys: String, CodingKey {
        case direction
        case colors
        case locations
    }
}

public extension Gradient {
    enum Direction: Equatable, Decodable {
        public static func == (lhs: Gradient.Direction, rhs: Gradient.Direction) -> Bool {
            switch (lhs, rhs) {
            case (.vertical, .vertical):
                return true
            case (.horizontal, .horizontal):
                return true
            case (.diagonalLTR, .diagonalLTR):
                return true
            case (.diagonalRTL, .diagonalRTL):
                return true
            case (.custom(let p1), .custom(let p2)):
                return p1 == p2
            default:
                return false
            }
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let stringValue = try container.decode(String.self)
            
            switch stringValue {
            case "vertical":
                self = .vertical
            case "horizontal":
                self = .horizontal
            case "diagonalLTR":
                self = .diagonalLTR
            case "diagonalRTL":
                self = .diagonalRTL
            default:
                self = .horizontal
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
