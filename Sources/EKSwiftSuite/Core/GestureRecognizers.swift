//
//  GestureRecognizers.swift
//  
//
//  Created by Eilon Krauthammer on 14/03/2021.
//

import UIKit

/// This class by default sets `cancelsTouchesInView` to `false`.
final class SmartPressGestureRecogizer: UILongPressGestureRecognizer {
    
    public var args: [String: Any] = [:]
    
    init(target: Any?, action: Selector?, minimumPressDuration: TimeInterval = 0.0) {
        super.init(target: target, action: action)
        self.minimumPressDuration = minimumPressDuration
    }
}
