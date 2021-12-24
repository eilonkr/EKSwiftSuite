//
//  SelectionItemButton.swift
//  Quoti
//
//  Created by Eilon Krauthammer on 15/04/2021.
//

#if !os(macOS)

import UIKit

final class SelectionItemButton: SpringButton {
    
    public let selectionItem: SelectionItem
    public private(set) var chosen: Bool = false
    public var tint: UIColor = .systemBlue {
        didSet {
            set(selected: chosen)
        }
    }
    
    public var activeTint: UIColor = .white {
        didSet {
            set(selected: chosen)
        }
    }
    
    init(item: SelectionItem) {
        self.selectionItem = item
        super.init(frame: .zero)
        
        set(selected: false)
        contentEdgeInsets = .init(vertical: 12.0, horizontal: 14.0)
        titleLabel?.font = .roundedFont(size: 12, weight: .bold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func set(selected: Bool) {
        setTitle(selectionItem.title, for: .normal)
        setTitleColor(selected ? activeTint : tint, for: .normal)
        //titleLabel?.font = .roundedFont(size: 12.0, weight: .semibold)
        self.chosen = selected
    }
    
}
#endif
