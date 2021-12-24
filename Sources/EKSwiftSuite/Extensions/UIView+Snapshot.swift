//
//  UIView+Snapshot.swift
//  
//
//  Created by Eilon Krauthammer on 31/03/2021.
//

#if !os(macOS)
import UIKit

public extension UIView {
    
    /// Use the preparation closure to configure the view before and after the snapshot was taken.
    func makeSnapshot(for subframe: CGRect? = nil, using preparation: ((Bool) -> Void)?) -> UIImage {
        preparation?(true)
        let renderer = UIGraphicsImageRenderer(bounds: subframe ?? bounds)
        let snapshotImage = renderer.image { context in
            layer.render(in: context.cgContext)
        }
        
        preparation?(false)
        return snapshotImage
    }
}
#endif
