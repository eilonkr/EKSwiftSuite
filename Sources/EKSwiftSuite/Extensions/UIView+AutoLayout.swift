
#if !os(macOS)
import UIKit
public typealias ViewType = UIView
public typealias EdgeInsets = UIEdgeInsets
#else
import AppKit
public typealias ViewType = NSView
public typealias EdgeInsets = NSEdgeInsets
#endif

public extension ViewType {
    func fix(in container: ViewType, padding: EdgeInsets = .init()) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.frame
        container.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: container.topAnchor, constant: padding.top),
            bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -padding.bottom),
            leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: padding.left),
            trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -padding.right)
        ])
    }
    
    func constraintAspectRatio(_ aspectRatio: CGFloat, width: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: aspectRatio).isActive = true
    }
    
    func center(in view: ViewType) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

