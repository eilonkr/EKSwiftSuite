
import UIKit

public extension CALayer {

    func roundCorners(to radius: CornerRadiusStyle, smoothCorners: Bool = true) {
        switch radius {
            case .rounded:
                cornerRadius = min(bounds.height/2, bounds.width/2)
            case .custom(let rad):
                cornerRadius = rad
            case .other(let view):
                cornerRadius = view.layer.cornerRadius
        }
        
        if bounds.width == bounds.height && radius == .rounded { return }
        if smoothCorners, #available(iOS 13.0, *) {
            cornerCurve = .continuous
        }
    }
    
    func applyShadow(color: UIColor = .black, radius: CGFloat = 6.0, opacity: Float = 0.2, offsetY: CGFloat = 3.0, offsetX: CGFloat = 0.0) {
        shadowColor = color.cgColor
        shadowOpacity = opacity
        shadowRadius = radius
        shadowOffset = CGSize(width: offsetX, height: offsetY)
    }
}
