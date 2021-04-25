//
//  Archiver.swift
//  BelongHomeOriject
//
//  Created by Eilon Krauthammer on 23/01/2020.
//  Copyright © 2020 Eilon Krauthammer. All rights reserved.
//

import Foundation

public protocol Directory {
    var path: String { get }
    var url: URL { get }
}

public protocol ArchiveItem: Codable {
    var key: String { get }
}

enum ArchiverError: Error {
    case fileDoesNotExist
}

/// A service I wrote for saving data locally to the device's documents directory.
public struct Archiver<D: Directory> {
    private let directory: D
    
    public init(_ directory: D) {
        self.directory = directory
    }
    
    private var pathPrefix: String { "appDocuments" }
    var baseURL: URL { URL(string: pathPrefix)!.appendingPathExtension(directory.url.appendingPathComponent(pathPrefix).path) }
    
    public func itemExists(forKey key: String) -> Bool {
        FileManager.default.fileExists(atPath: baseURL.appendingPathComponent(fn(key)).path)
    }
    
    public func put<T: ArchiveItem>(_ item: T) throws {
        if !FileManager.default.fileExists(atPath: directory.path) {
            // Directory doesn't exist.
            try createDirectory()
        }
        
        let data = try JSONEncoder().encode(item)
        let path = baseURL.appendingPathComponent(fn(item.key))
        try data.write(to: path)
    }
    
    public func get<T: ArchiveItem>(_ : T.Type, for key: String) -> T? {
        let path = baseURL.appendingPathComponent(fn(key))
        guard
            let data = try? Data(contentsOf: path),
            let object = try? JSONDecoder().decode(T.self, from: data)
        else { return .none }
        return object
    }
    
    public func all<T: ArchiveItem>(_: T.Type, pathExtension: String? = nil) throws -> [T]? {
        let contents = try FileManager.default.contentsOfDirectory(at: baseURL, includingPropertiesForKeys: nil, options: [])
        
        var entries = [T]()
        for file in contents {
            let data = try Data(contentsOf: file)
            let object = try JSONDecoder().decode(T.self, from: data)
            entries.append(object)
        }
        
        return entries
    }
    
    public func delete<T: ArchiveItem>(_ item: T) throws {
        let url = baseURL.appendingPathComponent(fn(item.key))
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        } else {
            throw ArchiverError.fileDoesNotExist
        }
    }
    
    public func removeAll() throws {
        try FileManager.default.removeItem(at: baseURL)
    }
    
    /// File name without extensions
    private func fn(_ key: String) -> String {
        key.filter { $0 != "." }
    }
    
    private func createDirectory() throws {
        try FileManager.default.createDirectory(atPath: baseURL.path, withIntermediateDirectories: true, attributes: nil)
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
    
    func subdirectory(from item: ArchiveItem, path: String) -> Archiver<Subdirectory> {
        let newURL = directory.url
            .appendingPathComponent(item.key)
            .appendingPathComponent(path)
        
        let subdirectory = Subdirectory(path: newURL.path, url: newURL)
        return Archiver<Subdirectory>(subdirectory)
    }
    
    func subdirectory(from: String, to: String) -> Archiver<Subdirectory> {
        let newURL = baseURL
            .appendingPathComponent(from)
            .appendingPathComponent(to)
        
        let subdirectory = Subdirectory(path: newURL.path, url: newURL)
        return Archiver<Subdirectory>(subdirectory)
    }
}

