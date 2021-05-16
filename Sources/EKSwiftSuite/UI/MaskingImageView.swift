//
//  MaskingImageView.swift
//  MaskTesting
//
//  Created by Eilon Krauthammer on 16/05/2021.
//

import UIKit

final class MaskingImageView: UIImageView {
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
        assert(maskImageView.image != nil, "Empty image mask.")
        maskImageView.frame = bounds
        mask = maskImageView
    }
}
