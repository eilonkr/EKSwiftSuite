//
//  BackgroundStyle.swift
//  
//
//  Created by Eilon Krauthammer on 18/06/2021.
//

import UIKit

enum BackgroundStyle {
    case solid(UIColor)
    case blur(UIBlurEffect.Style)
    var effectStyle: UIBlurEffect.Style? {
        if case .blur(let style) = self {
            return style
        }
        return nil
    }
    
    var color: UIColor? {
        if case .solid(let color) = self {
            return color
        }
        return nil
    }
}
