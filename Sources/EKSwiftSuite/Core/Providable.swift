//
//  Providable.swift
//  
//
//  Created by Eilon Krauthammer on 16/04/2021.
//

import Foundation

protocol Providable {
    associatedtype Item
    func provide(_ item: Item)
}
