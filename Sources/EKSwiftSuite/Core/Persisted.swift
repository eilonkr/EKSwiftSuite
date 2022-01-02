//
//  Persisted.swift
//  
//
//  Created by Eilon Krauthammer on 02/10/2021.
//

import Foundation

public struct AnyDirectory: Directory {
    public let path: String
    public init<D: Directory>(_ d: D) {
        self.path = d.path
    }
}

public extension Directory {
    func eraseToAnyDirectory() -> AnyDirectory {
        return AnyDirectory(self)
    }
}

@propertyWrapper
public struct Persisted<Value: Codable> {
    public init(key: String, defaultValue: Value, directory: AnyDirectory) {
        self.key = key
        self.defaultValue = defaultValue
        self.archiver = Archiver(directory)
    }
    
    let defaultValue: Value
    let key: String
    let archiver: Archiver<AnyDirectory>
    
    public var wrappedValue: Value {
        get {
            archiver.get(itemForKey: key, ofType: Value.self) ?? defaultValue
        } set {
            try? archiver.put(newValue, for: key)
        }
    }
}
