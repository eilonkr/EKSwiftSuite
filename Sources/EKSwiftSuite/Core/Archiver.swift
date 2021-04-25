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
    
    public func itemExists(forKey key: String) -> Bool {
        FileManager.default.fileExists(atPath:
            self.directory.url.appendingPathComponent(fn(key)).path)
    }
    
    public func put<T: ArchiveItem>(_ item: T, inSubdirectory subdir: String? = nil) throws {
        if !FileManager.default.fileExists(atPath: directory.path) {
            // Directory doesn't exist.
            try createDirectory(extension: subdir ?? directory.path)
        }
        
        let data = try JSONEncoder().encode(item)
        let path = self.directory.url.appendingPathComponent(fn(item.key))
        try data.write(to: path)
    }
    
//    public func get<T: ArchiveItem>(_ : T.Type, for key: String) -> T? {
//        guard
//            let data = try? Data(contentsOf: path),
//            let object = try? JSONDecoder().decode(T.self, from: data)
//        else { return .none }
//        return object
//    }
    
    public func all<T: ArchiveItem>(_: T.Type, pathExtension: String? = nil) throws -> [T]? {
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
        } else {
            throw ArchiverError.fileDoesNotExist
        }
    }
    
    public func removeAll(extension ext: String? = nil) throws {
        let url = directory.url
        try FileManager.default.removeItem(at: url)
    }
    
    /// File name without extensions
    private func fn(_ key: String) -> String {
        key.filter { $0 != "." }
    }
    
    private func createDirectory(extension ext: String? = nil) throws {
        try FileManager.default.createDirectory(atPath: directory.path, withIntermediateDirectories: true, attributes: nil)
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
    
    func subdirectory(from item: ArchiveItem, path: String) -> Archiver<Subdirectory> {
        let newURL = directory.url
            .appendingPathComponent(item.key)
            .appendingPathComponent(path)
        
        let subdirectory = Subdirectory(path: newURL.path, url: newURL)
        return Archiver<Subdirectory>(subdirectory)
    }
}

