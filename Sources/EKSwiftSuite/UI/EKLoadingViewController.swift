//
//  File.swift
//  
//
//  Created by Eilon Krauthammer on 05/02/2021.
//

import UIKit

public class EKLoadingViewController: UIViewController {
    
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
    
    public init(style: Style = .default, indicatorStyle: UIActivityIndicatorView.Style, backgroundOpacity: CGFloat = 0.75, infoText: String? = nil) {
        self.style = style
        self.indicatorStyle = indicatorStyle
        self.backgroundOpacity = backgroundOpacity
        self.infoText = infoText
        
        super.init(nibName: nil, bundle: Bundle.module)
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
        loadingStackView.addSubview(activityIndicator)
        view.backgroundColor = style.backgroundColor.withAlphaComponent(backgroundOpacity)
        activityIndicator.sizeToFit()
        activityIndicator.startAnimating()
        activityIndicator.tintColor = style.tintColor
        activityIndicator.color = style.tintColor
        
        if let text = self.infoText {
            let label = UILabel()
            label.text = text
            label.textColor = style.tintColor
            label.font = .preferredFont(forTextStyle: .body)
            label.sizeToFit()
            loadingStackView.addArrangedSubview(label)
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loadingStackView.center = CGPoint(
            x: view.bounds.width  / 2,
            y: view.bounds.height / 2
        )
    }
}

// MARK: - Style

public extension EKLoadingViewController {
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
    func startLoadingInterface(style: EKLoadingViewController.Style = .default, indicatorStyle: UIActivityIndicatorView.Style, backgroundOpacity: CGFloat = 0.75, infoText: String? = nil) {
        let loadingViewController = EKLoadingViewController(style: style, indicatorStyle: indicatorStyle, backgroundOpacity: backgroundOpacity, infoText: infoText)
        present(loadingViewController, animated: true, completion: nil)
    }
    
    func stopLoadingInterface(completion: (() -> Void)? = nil, rootDismiss: Bool = false) {
        if let child = children.first(where: { $0 is EKLoadingViewController }) as? EKLoadingViewController {
            let dismisser = rootDismiss ? self : child
            dismisser.dismiss(animated: true, completion: completion)
        }
    }
}
