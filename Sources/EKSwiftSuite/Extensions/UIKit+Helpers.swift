
import UIKit

// UI related Value Types

public extension CGSize {
    static func square(_ side: CGFloat) -> CGSize {
        return .init(width: side, height: side)
    }
}

public extension CGAffineTransform {
    static func evenScale(_ value: CGFloat) -> CGAffineTransform {
        return .init(scaleX: value, y: value)
    }
    
    func evenScaled(_ value: CGFloat) -> CGAffineTransform {
        return scaledBy(x: value, y: value)
    }
}

public extension UIEdgeInsets {
    static func even(_ value: CGFloat) -> UIEdgeInsets {
        return .init(top: value, left: value, bottom: value, right: value)
    }
    
    static func vertical(_ v: CGFloat, horizontal h: CGFloat) -> UIEdgeInsets {
        return .init(top: v, left: h, bottom: v, right: h)
    }
}
