//
//  UIFont+Extension.swift
//  
//
//  Created by Eilon Krauthammer on 17/03/2021.
//

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
}
