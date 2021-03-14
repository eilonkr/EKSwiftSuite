//
//  UserDefault.swift
//  
//
//  Created by Eilon Krauthammer on 06/01/2021.
//

import Foundation

@propertyWrapper
public struct UserDefault<Value> {
    public init(key: String, defaultValue: Value, container: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.container = container
    }
    
    let key: String
    let defaultValue: Value
    let container: UserDefaults
    public var wrappedValue: Value {
        get {
            container.object(forKey: key) as? Value ?? defaultValue
        } set {
            container.set(newValue, forKey: key)
        }
    }
}
