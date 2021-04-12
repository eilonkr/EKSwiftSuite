//
//  UIView+Snapshot.swift
//  
//
//  Created by Eilon Krauthammer on 31/03/2021.
//

import UIKit

public extension UIView {
    
    /// Use the preparation closure to configure the view before and after the snapshot was taken.
    func makeSnapshot(for subframe: CGRect? = nil, using preparation: ((Bool) -> Void)?) -> UIImage {
        preparation?(true)
        let renderer = UIGraphicsImageRenderer(bounds: subframe ?? bounds)
        let snapshotImage = renderer.image { context in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
        
        preparation?(false)
        return snapshotImage
    }
}
