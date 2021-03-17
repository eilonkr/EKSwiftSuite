//
//  SheetViewController.swift
//  Quoti
//
//  Created by Eilon Krauthammer on 17/03/2021.
//

import UIKit

public enum DismissState {
    case closeButtonTap
    case dimmedViewTap
}

public protocol SheetViewControllerOutput: AnyObject {
    func sheetViewController(_ controller: SheetViewController, wantsDismissAt dismissState: DismissState)
}

open class SheetViewController: UIViewController {
    public struct Appearance {
        let tintColor: UIColor
        let backgroundColor: UIColor
        let backgroundDimColor: UIColor
        let backgroundDimLevel: CGFloat
        let closeImage: UIImage
        
        public init(tintColor: UIColor, backgroundColor: UIColor, backgroundDimColor: UIColor, backgroundDimLevel: CGFloat, closeImage: UIImage) {
            self.tintColor = tintColor
            self.backgroundColor = backgroundColor
            self.backgroundDimColor = backgroundDimColor
            self.backgroundDimLevel = backgroundDimLevel
            self.closeImage = closeImage
        }
    }

    private let transition = SheetTransition()
    
    let appearance: Appearance
    let contentContainerView: UIView = UIView()
    let contentView: UIView
    
    weak var output: SheetViewControllerOutput?
    
    public init(contentView: UIView, appearance: Appearance, output: SheetViewControllerOutput?) {
        self.contentView = contentView
        self.appearance = appearance
        self.output = output
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        contentView = .init()
        appearance = .init(tintColor: .systemBlue, backgroundColor: .white, backgroundDimColor: .white, backgroundDimLevel: 0.34, closeImage: .init())
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        transitioningDelegate = transition
        modalPresentationStyle = .overFullScreen
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = appearance.backgroundDimColor.withAlphaComponent(appearance.backgroundDimLevel)
        
        configureContentView()
        configureCloseButton()
        configureDismissTapGesture()
    }
    
    private func configureContentView() {
        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentContainerView)
        NSLayoutConstraint.activate([
            contentContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentContainerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            contentContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        contentView.fix(in: contentContainerView)
    }
    
    private func configureCloseButton() {
        let closeButton = SpringButton()
        closeButton.setImage(appearance.closeImage, for: .normal)
        closeButton.tintColor = appearance.tintColor
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.contentEdgeInsets = .even(4.0)
        contentContainerView.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: 12).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -23).isActive = true
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    }
    
    private func configureDismissTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dimmedViewTapped))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func closeTapped() {
        output?.sheetViewController(self, wantsDismissAt: .closeButtonTap)
    }
    
    @objc private func dimmedViewTapped() {
        output?.sheetViewController(self, wantsDismissAt: .dimmedViewTap)
    }
}

extension SheetViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return gestureRecognizer.view === touch.view
    }
}
