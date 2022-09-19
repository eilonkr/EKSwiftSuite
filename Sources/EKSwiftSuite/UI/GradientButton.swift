//
//  GradientButton.swift
//  Word Story
//
//  Created by Eilon Krauthammer on 22/04/2021.
//

#if !os(macOS)
import UIKit

public class GradientButton: SpringButton {
    
    private lazy var gradientView = GradientView(gradient: .init(direction: .horizontal, colors: [.red]))
    
    @IBInspectable var usesRoundedCorners: Bool = false {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    public var gradient: Gradient {
        get {
            return gradientView.gradient
        } set {
            gradientView.gradient = newValue
        }
    }
    
    public var shadowColor: UIColor = UIColor.black.withAlphaComponent(0.1) {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addSubview(gradientView)
        gradientView.isUserInteractionEnabled = false
        applyShadow(color: shadowColor, radius: 8.0, opacity: 1.0, offsetY: 4.0)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if usesRoundedCorners {
            roundCorners(to: .rounded)
        }
        gradientView.roundCorners(to: .other(self))
        gradientView.frame = bounds
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    
}
#endif
