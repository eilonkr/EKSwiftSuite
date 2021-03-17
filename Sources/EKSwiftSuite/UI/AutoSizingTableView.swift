//
//  AutoSizingTableView.swift
//
//
//  Created by Eilon Krauthammer on 17/03/2021.
//

import UIKit

open class AutoSizingTableView: UITableView {
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: contentSize.width, height: contentSize.height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.invalidateIntrinsicContentSize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
