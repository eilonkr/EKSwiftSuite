//
//  Binding.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 18/11/2020.
//

import Foundation

open class Binding<T> {
    public typealias Handler = (T) -> Void
    
    public var handlers: [Handler?] = []
    
    public var value: T {
        didSet {
            handler?(value)
            for handler in handlers {
                handler?(value)
            }
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
    
    public func add(_ handler: Handler?) {
        handler?(value)
        handlers.append(handler)
    }
}

