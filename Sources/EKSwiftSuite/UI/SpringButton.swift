//
//  PopableButton.swift
//  
//
//  Created by Eilon Krauthammer on 14/03/2021.
//

import UIKit

open class SpringButton: UIButton, SpringableView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        adjustsImageWhenHighlighted = false
        configurePop()
    }
    
    func configurePop() {
        addSpringOnTap()
    }
}
