//
//  TextAndIconButton.swift
//  
//
//  Created by Eilon Krauthammer on 17/03/2021.
//
#if !os(macOS)


import UIKit

open class TextAndIconButton: SpringButton {
    
    public var titlePosition: Position {
        didSet {
            commonInit()
        }
    }
    
    open override func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image, for: state)
        commonInit()
    }
    
    open override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
    }
    
    init(titlePosition: Position, imagePosition: Position, spacing: CGFloat = 8.0) {
        self.titlePosition = titlePosition
        super.init(frame: .zero)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        self.titlePosition = .left
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.set(image: currentImage, title: currentTitle ?? "", titlePosition: titlePosition, additionalSpacing: 4.0, state: .normal)
    }
    
}
#endif
