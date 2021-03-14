
import UIKit

public extension UIView {
    func roundCorners(to style: CornerRadiusStyle) {
        layer.roundCorners(to: style)
    }
    
    func applyShadow(color: UIColor = .black, radius: CGFloat = 6.0, opacity: Float = 0.2, offsetY: CGFloat = 3.0, offsetX: CGFloat = 0.0) {
        layer.applyShadow(color: color, radius: radius, opacity: opacity, offsetY: offsetY, offsetX: offsetX)
    }
}

public extension UIView {
    
    func bindFrameToSuperviewBounds(with constant: CGFloat = 0, offset: CGPoint = .zero) {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: offset.x).isActive = true
        self.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: offset.y).isActive = true
        self.widthAnchor.constraint(equalTo: superview.widthAnchor, constant: constant).isActive = true
        self.heightAnchor.constraint(equalTo: superview.heightAnchor, constant: constant).isActive = true
    }
    
    func bindMarginsToSuperview(insets: UIEdgeInsets = .zero) {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: insets.right).isActive = true
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: insets.bottom).isActive = true
    }
    
    class func fromNib<T: UIView>(bundle: Bundle = .main) -> T {
        return bundle.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func bindMarginsToSuperviewWithBottomSafeArea(insets: UIEdgeInsets = .zero) {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: insets.right).isActive = true
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: insets.bottom).isActive = true
    }
    
    func bindMarginsTo(view: UIView, insets: UIEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.right).isActive = true
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom).isActive = true
    }
    
}
