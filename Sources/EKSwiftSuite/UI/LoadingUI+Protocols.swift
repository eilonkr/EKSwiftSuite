//
//  LoadingUI+Protocols.swift
//  EKSwiftSuite
//
//  Created by Eilon Krauthammer on 03/08/2021.
//

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
    func startLoadingOverlay(inside subview: UIView? = nil, duration: TimeInterval = 0.2) {
        if let subview = subview, subview.isDescendant(of: view) {
            subview.isUserInteractionEnabled = false
            let loadingViewController = LoadingViewController(configuration: loadingConfiguration)
            loadingViewController.view.alpha = 0.0
            loadingViewController.view.layer.zPosition = .greatestFiniteMagnitude
            loadingViewController.addAsChildTo(parentVc: self, inside: subview)
            loadingViewController.loadViewIfNeeded()
            UIView.animate(withDuration: duration) {
                loadingViewController.view.alpha = 1.0
            }
        } else {
            guard presentedViewController is LoadingViewController == false else { return }
            let loadingViewController = LoadingViewController(configuration: loadingConfiguration)
            present(loadingViewController, animated: true, completion: nil)
        }
    }
    
    func dismissLoadingOverlay(duration: TimeInterval = 0.2) {
        if let child = children.first(where: { $0 is LoadingViewController } ) {
            child.view.superview?.isUserInteractionEnabled = true
            UIView.animate(withDuration: duration) {
                child.view.alpha = 0.0
            } completion: { _ in
                child.removeChildViewController()
            }
        } else if let loadingViewController = presentedViewController as? LoadingViewController {
            loadingViewController.dismiss(animated: true, completion: nil)
        }
    }
}
