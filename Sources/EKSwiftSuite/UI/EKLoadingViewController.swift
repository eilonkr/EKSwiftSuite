//
//  File.swift
//  
//
//  Created by Eilon Krauthammer on 05/02/2021.
//

import UIKit

open class LoadingViewController: UIViewController {
    
    let style: Style
    let indicatorStyle: UIActivityIndicatorView.Style
    let backgroundOpacity: CGFloat
    let infoText: String?
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: self.indicatorStyle)
    
    private let loadingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12.0
        stack.alignment = .center
        return stack
    }()
    
    @available(iOS 13.0, *)
    public init(style: Style = .default, indicatorStyle: UIActivityIndicatorView.Style = .medium, backgroundOpacity: CGFloat = 0.75, infoText: String? = nil) {
        self.style = style
        self.indicatorStyle = indicatorStyle
        self.backgroundOpacity = backgroundOpacity
        self.infoText = infoText
        
        super.init(nibName: nil, bundle: nil)
        setupTransition()
    }
    
    public init(oldStyle: Style = .default, indicatorStyle: UIActivityIndicatorView.Style = .white, backgroundOpacity: CGFloat = 0.75, infoText: String? = nil) {
        self.style = oldStyle
        self.indicatorStyle = indicatorStyle
        self.backgroundOpacity = backgroundOpacity
        self.infoText = infoText
        
        super.init(nibName: nil, bundle: nil)
        setupTransition()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("Please add me programmatically only.")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func setupTransition() {
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    private func configure() {
        view.addSubview(loadingStackView)
        loadingStackView.addArrangedSubview(activityIndicator)
        view.backgroundColor = style.backgroundColor.withAlphaComponent(backgroundOpacity)
        activityIndicator.startAnimating()
        activityIndicator.tintColor = style.tintColor
        activityIndicator.color = style.tintColor
        
        if let text = self.infoText {
            let label = UILabel()
            label.text = text
            label.textColor = style.tintColor
            label.font = .preferredFont(forTextStyle: .body)
            label.textAlignment = .center
            loadingStackView.addArrangedSubview(label)
        }
        
        loadingStackView.center(in: view)
    }
}

// MARK: - Style

public extension LoadingViewController {
    enum Style {
        case `default`
        case light
        case custom(UIColor)
        
        var backgroundColor: UIColor {
            switch self {
                case .default:
                    return .black
                case .light:
                    return .white
                case .custom(let color):
                    return color
            }
        }
        
        var tintColor: UIColor {
            switch self {
                case .default, .custom(_):
                    return .white
                case .light:
                    return .darkGray
            }
        }
    }
}

// MARK: - Global Presentation

public extension UIViewController {
    @available(iOS 13.0, *)
    func startLoadingInterface(style: LoadingViewController.Style = .default, indicatorStyle: UIActivityIndicatorView.Style = .medium, backgroundOpacity: CGFloat = 0.75, infoText: String? = nil) {
        guard !(presentedViewController is LoadingViewController) else { return }
        let loadingViewController = LoadingViewController(style: style, indicatorStyle: indicatorStyle, backgroundOpacity: backgroundOpacity, infoText: infoText)
        present(loadingViewController, animated: true, completion: nil)
    }
    
    func startOldLoadingInterface(style: LoadingViewController.Style = .default, indicatorStyle: UIActivityIndicatorView.Style = .white, backgroundOpacity: CGFloat = 0.75, infoText: String? = nil) {
        guard !(presentedViewController is LoadingViewController) else { return }
        let loadingViewController = LoadingViewController(oldStyle: style, indicatorStyle: indicatorStyle, backgroundOpacity: backgroundOpacity, infoText: infoText)
        present(loadingViewController, animated: true, completion: nil)
    }
    
    func stopLoadingInterface(completion: (() -> Void)? = nil, rootDismiss: Bool = false) {
        if let loadingViewController = presentedViewController as? LoadingViewController {
            let dismisser = rootDismiss ? self : loadingViewController
            dismisser.dismiss(animated: true, completion: completion)
        }
    }
}
