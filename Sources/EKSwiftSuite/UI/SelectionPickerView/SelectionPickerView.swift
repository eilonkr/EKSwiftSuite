//
//  SelectionPickerView.swift
//  Quoti
//
//  Created by Eilon Krauthammer on 15/04/2021.
//

import UIKit

public protocol SelectionItem {
    var title: String { get }
}

open class SelectionPickerView<Item: SelectionItem>: UIView {

    public var items: [Item] = [] {
        didSet { configureItems() }
    }
    
    public var selectedItem: Item? {
        didSet { setSelectedItem() }
    }
    
    public var backgroundStyle: BackgroundStyle = .solid(.white) {
        didSet {
            configureBackgroundStyle()
        }
    }
    
    public var tint: UIColor = .systemBlue {
        didSet {
            configureColors()
        }
    }
    
    public var activeTint: UIColor = .white {
        didSet {
            configureColors()
        }
    }
    
    public var onSelect: ((Item) -> Void)?
    
    private let itemsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0.0
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private lazy var highlightView: UIView = {
        let view = UIView()
        view.backgroundColor = activeTint
        return view
    }()
    
    private lazy var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: backgroundStyle.effectStyle ?? .regular))
    
    public init(items: [Item] = [], selectedItem: Item) {
        self.items = items
        self.selectedItem = selectedItem
        super.init(frame: .zero)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(to: .rounded)
        highlightView.roundCorners(to: .rounded)
    }
    
    // MARK: - Configuration
    
    private func commonInit() {
        clipsToBounds = true
        
        addSubview(highlightView)
        itemsStack.fix(in: self)
        
        configureItems()
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        //configureBackgroundStyle()
        DispatchQueue.main.async {
            self.setSelectedItem()
        }
    }
    
    private func configureItems() {
        layoutIfNeeded()
        if itemsStack.arrangedSubviews.count > 0 {
            for view in itemsStack.arrangedSubviews {
                itemsStack.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        }
        
        for itemButton in (items.map { SelectionItemButton(item: $0) }) {
            itemsStack.addArrangedSubview(itemButton)
            itemButton.addTarget(self, action: #selector(itemButtonTapped), for: .touchUpInside)
        }
    }
    
    private func configureBackgroundStyle() {
        backgroundColor = backgroundStyle.color
        if let blurStyle = backgroundStyle.effectStyle {
            if !visualEffectView.isDescendant(of: self) {
                visualEffectView.fix(in: self)
                sendSubviewToBack(visualEffectView)
            }
            visualEffectView.effect = UIBlurEffect(style: blurStyle)
        } else {
            if visualEffectView.isDescendant(of: self) {
                visualEffectView.removeFromSuperview()
            }
        }
    }
    
    private func configureColors() {
        highlightView.backgroundColor = tint
        for case let button as SelectionItemButton in itemsStack.arrangedSubviews {
            button.tint = tint
            button.activeTint = activeTint
        }
    }
    
    private func setSelectedItem() {
        layoutIfNeeded()
        var selectedButton: SelectionItemButton?
        for case let itemButton as SelectionItemButton in itemsStack.arrangedSubviews {
            itemButton.set(selected: itemButton.selectionItem.title == selectedItem?.title)
            if itemButton.selectionItem.title == selectedItem?.title {
                selectedButton = itemButton
            }
        }
        
        guard let button = selectedButton else { return }
        guard highlightView.frame != .zero else {
            highlightView.frame = button.frame.insetBy(dx: 4, dy: 4)
            return
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveEaseInOut, .allowUserInteraction]) {
            self.highlightView.frame = button.frame.insetBy(dx: 4, dy: 4)
        }
    }
    
    @objc private func itemButtonTapped(_ sender: SelectionItemButton) {
        Haptic.selection.generate()
        guard let item = sender.selectionItem as? Item else { return }
        selectedItem = item
        onSelect?(item)
    }
}
