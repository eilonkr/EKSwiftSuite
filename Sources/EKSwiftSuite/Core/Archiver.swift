
//
//  Archiver.swift
//  EKSwiftSuite
//
//  Created by Eilon Krauthammer on 23/01/2020.
//  Copyright © 2020 Eilon Krauthammer. All rights reserved.
//
import Foundation

public protocol Directory {
    var path: String { get }
    var url: URL { get }
}

public extension Directory {
    var url: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(path)
    }
}

/// A service I wrote for saving data locally to the device's documents directory.
public struct Archiver<D: Directory> {
    private let directory: D
    
    public init(_ directory: D) {
        self.directory = directory
    }
    
    public func itemExists(for key: String) -> Bool {
        FileManager.default.fileExists(atPath:
            self.directory.url.appendingPathComponent(fn(key)).path)
    }
    
    public func put<T: Encodable>(_ item: T, for key: String) throws {
        try createDirectoryIfNeeded()
        
        let data = try JSONEncoder().encode(item)
        let path = self.directory.url.appendingPathComponent(fn(key))
        try data.write(to: path)
    }
    

    public func get<T: Decodable>(itemForKey key: String, ofType _: T.Type) -> T? {
        let path = self.directory.url.appendingPathComponent(fn(key))
        guard
            let data = try? Data(contentsOf: path),
            let object = try? JSONDecoder().decode(T.self, from: data)
        else { return .none }
        return object
    }
    
    public func all<T: Decodable>(_: T.Type) throws -> [T]? {
        let contents = try FileManager.default.contentsOfDirectory(at: directory.url, includingPropertiesForKeys: nil, options: [])
        
        var entries = [T]()
        for file in contents {
            let data = try Data(contentsOf: file)
            let object = try JSONDecoder().decode(T.self, from: data)
            entries.append(object)
        }
        
        return entries
    }
    
    public func deleteItem(for key: String) throws {
        let url = self.directory.url.appendingPathComponent(fn(key))
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
    }
    
    public func removeAll(extension: String? = nil) throws {
        let url = directory.url.appendingPathComponent(`extension` ?? directory.path)
        try FileManager.default.removeItem(at: url)
    }
    
    /// File name without extensions
    private func fn(_ key: String) -> String {
        key.filter { $0 != "." }
    }
    
    private func createDirectoryIfNeeded() throws {
        if !FileManager.default.fileExists(atPath: directory.url.path) {
            // Directory doesn't exist.
        
            try FileManager.default.createDirectory(atPath: directory.url.path, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    /// Clears all archives from all directories.
    static func clearAllCache(allCases: [D]) throws {
        for path in allCases {
            try Self(path).removeAll()
        }
    }
}

public extension Archiver {
    struct Subdirectory: Directory {
        public var path: String
        public var url: URL
    }
    
    func subdirectory(from nodePath: String, for key: String) -> Archiver<Subdirectory> {
        let newURL = directory.url
            .appendingPathComponent(nodePath)
            .appendingPathComponent(key)
        
        let subdirectory = Subdirectory(path: path, url: newURL)
        return Archiver<Subdirectory>(subdirectory)
    }
}

