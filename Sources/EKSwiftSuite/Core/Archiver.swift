
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

/// A service I wrote for saving data locally to the device's documents directory.
public struct Archiver<D: Directory> {
    private let directory: D
    
    public init(_ directory: D) {
        self.directory = directory
    }
    
    public func itemExists(forKey key: String) -> Bool {
        FileManager.default.fileExists(atPath:
            self.directory.url.appendingPathComponent(fn(key)).path)
    }
    
    public func put<T: Encodable>(_ item: T, forKey key: String, inSubdirectory subdir: String? = nil) throws {
        if !FileManager.default.fileExists(atPath: directory.url.appendingPathComponent(subdir ?? directory.path).path) {
            // Directory doesn't exist.
            try createDirectory(extension: subdir ?? directory.path)
        }
        
        let data = try JSONEncoder().encode(item)
        let path = self.directory.url.appendingPathComponent(subdir ?? directory.path).appendingPathComponent(fn(key))
        try data.write(to: path)
    }
    

    public func get<T: Decodable>(itemForKey key: String, ofType _: T.Type) -> T? {
        let path = self.directory.url.appendingPathComponent(directory.path).appendingPathComponent(fn(key))
        guard
            let data = try? Data(contentsOf: path),
            let object = try? JSONDecoder().decode(T.self, from: data)
        else { return .none }
        return object
    }
    
    public func all<T: Decodable>(_: T.Type, pathExtension: String? = nil) throws -> [T]? {
        let contents = try FileManager.default.contentsOfDirectory(at: directory.url.appendingPathComponent(pathExtension ?? directory.path), includingPropertiesForKeys: nil, options: [])
        
        var entries = [T]()
        for file in contents {
            let data = try Data(contentsOf: file)
            let object = try JSONDecoder().decode(T.self, from: data)
            entries.append(object)
        }
        
        return entries
    }
    
    public func deleteItem(forKey key: String) throws {
        let url = self.directory.url.appendingPathComponent(directory.path).appendingPathComponent(fn(key))
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
    }
    
    public func removeAll(extension ext: String? = nil) throws {
        let url = directory.url.appendingPathComponent(ext ?? directory.path)
        try FileManager.default.removeItem(at: url)
    }
    
    /// File name without extensions
    private func fn(_ key: String) -> String {
        key.filter { $0 != "." }
    }
    
    private func createDirectory(extension ext: String? = nil) throws {
        try FileManager.default.createDirectory(atPath: directory.url.appendingPathComponent(ext ?? "").path, withIntermediateDirectories: true, attributes: nil)
    }
    
    /// Clears all archives from all directories.
    static func clearAllCache(allCases: [D]) throws {
        for path in allCases {
            try Self(path).removeAll()
        }
    }
}

extension Archiver {
    struct Subdirectory: Directory {
        var path: String
        var url: URL
    }
    
    func subdirectory(_ path: String) -> Archiver<Subdirectory> {
        let newURL = directory.url.appendingPathComponent(path)
        let subdirectory = Subdirectory(path: newURL.path, url: newURL)
        return Archiver<Subdirectory>(subdirectory)
    }
}

