//
//  MaskingImageView.swift
//  MaskTesting
//
//  Created by Eilon Krauthammer on 16/05/2021.
//

import UIKit

class MaskingImageView: UIImageView {
    private let maskImageView = UIImageView()

    public var maskImage: UIImage? {
        didSet {
            maskImageView.image = maskImage
            updateView()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
    }

    private func updateView() {
        if maskImageView.image != nil {
            maskImageView.frame = bounds
            mask = maskImageView
        }
    }
}
