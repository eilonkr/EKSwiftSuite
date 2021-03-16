//
//  ForceViewUpdate.swift
//  
//
//  Created by Eilon Krauthammer on 16/03/2021.
//

import Foundation

public protocol ForceViewUpdate {

    func update<T, U: Equatable>(new newViewModel: T,
                                 old oldViewModel: T,
                                 keyPath: KeyPath<T, U>,
                                 force: Bool,
                                 configurationBlock: (U) -> Void)
}

public extension ForceViewUpdate {

    func update<T, U: Equatable>(new newViewModel: T,
                                 old oldViewModel: T,
                                 keyPath: KeyPath<T, U>,
                                 force: Bool,
                                 configurationBlock: (U) -> Void) {
        let newValue = newViewModel[keyPath: keyPath]
        if force {
            configurationBlock(newValue)
        }
        else if oldViewModel[keyPath: keyPath] != newValue {
            configurationBlock(newValue)
        }
    }
}
