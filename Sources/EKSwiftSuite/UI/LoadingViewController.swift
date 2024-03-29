//
//  Loadable+UIViewController.swift
//  Blurify
//
//  Created by Eilon Krauthammer on 13/06/2021.
//

#if !os(macOS)

import UIKit
//import Lottie

@available(iOS 13, *)
open class LoadingViewController: UIViewController {
    
    let configuration: Configuration
    
    private let loadingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12.0
        stack.alignment = .center
        return stack
    }()
    
    public init(configuration: Configuration) {
        self.configuration = configuration
        
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required public init?(coder: NSCoder) {
        fatalError("Please add me programmatically only.")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        let appearance = configuration.appearance
        
        var animateable: LoadingAnimateable
        switch configuration.animation {
            case .indicator(let style):
                let indicator = UIActivityIndicatorView(style: style)
                indicator.tintColor = appearance.tint
                indicator.color = appearance.tint
                animateable = indicator
            case .view(let animateableView):
                animateable = animateableView
        }
        
        if case .view(_) = configuration.animation {
            animateable.fix(in: view)
        } else {
            view.addSubview(loadingStackView)
            loadingStackView.center(in: view)
            loadingStackView.addArrangedSubview(animateable)
        }
        
        view.backgroundColor = appearance.backgroundStyle.color.withAlphaComponent(appearance.backgroundOpaqueness)
        animateable.startAnimating()
        
        if case .blur(let blurEffectStyle, _) = appearance.backgroundStyle {
            let blurEffect = UIBlurEffect(style: blurEffectStyle)
            let blurView = UIVisualEffectView(effect: blurEffect)
            view.insertSubview(blurView, at: 0)
            blurView.bindMarginsToSuperview()
        }
        
        if let text = configuration.infoText {
            let label = UILabel()
            label.text = text
            label.textColor = appearance.tint
            label.font = appearance.infoFont ?? Appearance.default.infoFont
            label.textAlignment = .center
            loadingStackView.addArrangedSubview(label)
        }
    }
}

// MARK: - Style

@available(iOS 13, *)
public extension LoadingViewController {
    enum Animation {
        case view(UIView & LoadingAnimateable)
        case indicator(UIActivityIndicatorView.Style = .medium)
    }
    
    enum BackgroundStyle {
        case color(UIColor)
        case blur(UIBlurEffect.Style, UIColor)
         
        var color: UIColor {
            switch self {
                case .color(let color), .blur(_, let color):
                    return color
            }
        }
    }
    
    struct Configuration {
        public var animation: Animation
        public var infoText: String?
        public var appearance: Appearance
        
        public init(animation: LoadingViewController.Animation, infoText: String? = nil, appearance: LoadingViewController.Appearance = .default) {
            self.animation = animation
            self.infoText = infoText
            self.appearance = appearance
        }
        
        public static var `default`: Configuration {
            return Configuration(
                animation: .indicator(.large),
                infoText: "just a sec...",
                appearance: .default
            )
        }
    }
    
    struct Appearance {
        public var backgroundStyle: BackgroundStyle
        public var backgroundOpaqueness: CGFloat
        public var tint: UIColor
        public var infoFont: UIFont?
        
        public init(backgroundStyle: LoadingViewController.BackgroundStyle, backgroundOpaqueness: CGFloat, tint: UIColor, infoFont: UIFont? = nil) {
            self.backgroundStyle = backgroundStyle
            self.backgroundOpaqueness = backgroundOpaqueness
            self.tint = tint
            self.infoFont = infoFont
        }
        
        public static var `default`: Appearance {
            .init(
                backgroundStyle: .color(.black),
                backgroundOpaqueness: 0.55,
                tint: .white,
                infoFont: .roundedFont(size: 13.0, weight: .semibold)
            )
        }
    }
}
#endif
