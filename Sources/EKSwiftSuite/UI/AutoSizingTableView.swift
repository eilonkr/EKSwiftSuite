//
//  AutoSizingTableView.swift
//
//
//  Created by Eilon Krauthammer on 17/03/2021.
//

import UIKit

open class AutoSizingTableView: UITableView {
    open override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: contentSize.width, height: contentSize.height)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.invalidateIntrinsicContentSize()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
}
