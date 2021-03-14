//
//  Binding.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 18/11/2020.
//

import Foundation

final class Binding<T> {
    typealias Handler = (T) -> Void
    
    public var value: T {
        didSet {
            handler?(value)
        }
    }
    
    private var handler: Handler?
    
    public init(_ value: T) {
        self.value = value
    }
    
    public func bind(_ handler: Handler?) {
        handler?(value)
        self.handler = handler
    }
}

