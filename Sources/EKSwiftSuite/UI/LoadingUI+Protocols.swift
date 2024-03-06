//
//  LoadingUI+Protocols.swift
//  EKSwiftSuite
//
//  Created by Eilon Krauthammer on 03/08/2021.
//
#if !os(macOS)


import UIKit
//import Lottie

public protocol LoadingAnimateable: UIView {
    func startAnimating()
}

@available(iOS 13, *)
public protocol UILoadable {
    var loadingConfiguration: LoadingViewController.Configuration { get }
}

@available(iOS 13, *)
public extension UILoadable {
    var loadingConfiguration: LoadingViewController.Configuration { .default }
}

extension UIActivityIndicatorView: LoadingAnimateable { }

@available(iOS 13, *)
public extension UILoadable where Self: UIViewController {
    var isDisplayingLoadingOverlay: Bool {
        return (presentedViewController as? LoadingViewController) != nil || children.first(where: { $0 is LoadingViewController }) != nil
    }
    
    func startLoadingOverlay(inside subview: UIView? = nil, animated: Bool = true, duration: TimeInterval = 0.2) {
        guard isDisplayingLoadingOverlay == false else {
            return
        }
        
        if let subview = subview, subview.isDescendant(of: view) {
            subview.isUserInteractionEnabled = false
            let loadingViewController = LoadingViewController(configuration: loadingConfiguration)
            loadingViewController.view.alpha = 0.0
            loadingViewController.view.layer.zPosition = .greatestFiniteMagnitude
            loadingViewController.addAsChildTo(parentVc: self, inside: subview)
            loadingViewController.loadViewIfNeeded()
            if animated {
                UIView.animate(withDuration: duration) {
                    loadingViewController.view.alpha = 1.0
                }
            } else {
                loadingViewController.view.alpha = 1.0
            }
        } else {
            guard presentedViewController is LoadingViewController == false else { return }
            let loadingViewController = LoadingViewController(configuration: loadingConfiguration)
            present(loadingViewController, animated: animated, completion: nil)
        }
    }
    
    func dismissLoadingOverlay(duration: TimeInterval = 0.2, completion: (() -> Void)? = nil) {
        if let child = children.first(where: { $0 is LoadingViewController } ) {
            child.view.superview?.isUserInteractionEnabled = true
            UIView.animate(withDuration: duration) {
                child.view.alpha = 0.0
            } completion: { _ in
                child.removeChildViewController()
                completion?()
            }
        } else if let loadingViewController = presentedViewController as? LoadingViewController {
            loadingViewController.dismiss(animated: true, completion: completion)
        }
    }
}
#endif
