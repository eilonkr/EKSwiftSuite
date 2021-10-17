//
//  HTTPReqeust+Helpers.swift
//  
//
//  Created by Eilon Krauthammer on 17/10/2021.
//

import Foundation

public enum NetworkingError: Error {
    case badRequest(HTTPURLResponse? = nil)
    case unknown
}

public enum HTTPMethod: String {
    case get, post, put, patch, delete
    
    var value: String {
        rawValue.uppercased()
    }
}

public struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void
    public init<T: Encodable>(_ wrapped: T) {
        _encode = wrapped.encode
    }

    public func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}

public extension Encodable {
    func eraseToAnyEncodable() -> AnyEncodable {
        return AnyEncodable(self)
    }
}
