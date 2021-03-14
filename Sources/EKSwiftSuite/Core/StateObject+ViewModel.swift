//
//  State+ViewModel.swift
//  VideoToPhoto
//
//  Created by Eilon Krauthammer on 12/01/2021.
//

import Foundation

protocol StateObject {
    associatedtype ViewModelType: ViewModel
    func viewModel() -> ViewModelType
}

protocol ViewModel {
    associatedtype StateType: StateObject
    static func viewModel(with state: StateType) -> Self
}

extension StateObject where Self == ViewModelType.StateType {
    func viewModel() -> ViewModelType {
        ViewModelType.viewModel(with: self)
    }
}


