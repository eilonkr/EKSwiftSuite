//
//  UIFont+Extension.swift
//  
//
//  Created by Eilon Krauthammer on 17/03/2021.
//

#if !os(macOS)
import UIKit

public extension UIFont {
    static func roundedFont(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let baseFont = UIFont.systemFont(ofSize: size, weight: weight)
        guard #available(iOS 13.0, *),
              let fontDescriptor = baseFont.fontDescriptor.withDesign(.rounded) else {
            return baseFont
        }
        let roundedFont = UIFont(descriptor: fontDescriptor, size: baseFont.pointSize)
        return roundedFont
    }
    
    static func fontWith(design: UIFontDescriptor.SystemDesign, size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let baseFont = UIFont.systemFont(ofSize: size, weight: weight)
        guard #available(iOS 13.0, *),
              let fontDescriptor = baseFont.fontDescriptor.withDesign(design) else {
            return baseFont
        }
        let roundedFont = UIFont(descriptor: fontDescriptor, size: baseFont.pointSize)
        return roundedFont
    }
    
    static func preferredFont(for style: TextStyle, weight: Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
    }
}
#endif
