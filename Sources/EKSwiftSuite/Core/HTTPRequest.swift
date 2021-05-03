//
//  HTTPRequest.swift
//  Oriient√
//
//  Created by Eilon Krauthammer on 02/05/2021.
//

import Foundation

protocol Endpoint {
    static var baseURLPath: String { get }
    var path: String { get }
    var url: URL { get }
}

extension Endpoint {
    var url: URL {
        return URL(string: Self.baseURLPath + path)!
    }
}

enum NetworkingError: Error {
    case badRequest
    case unknown
}

enum HTTPMethod: String {
    case get, post, put, patch, delete
    
    var value: String {
        rawValue.uppercased()
    }
}

/// A simple HTTP layer I wrote.
protocol HTTPRequest {
    var endpoint: Endpoint              { get }
    var method: HTTPMethod              { get }
    var headers: [String: String]       { get }
    var queryParams: [String: String]?  { get }
    
    typealias ResultCallback<T: Decodable> = (Result<T, Error>) -> Void
    func make<U: Decodable>(expect type: U.Type, receiveOn receivingQueue: DispatchQueue, callback: @escaping ResultCallback<U>)
    func make<T: Encodable, U: Decodable>(send some: T, expect type: U.Type, receiveOn queue: DispatchQueue, callback: @escaping ResultCallback<U>)
}

/// URLSession implementation.
extension HTTPRequest {
    func make<U: Decodable>(expect type: U.Type, receiveOn receivingQueue: DispatchQueue = .main, callback: @escaping ResultCallback<U>) {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = method.value
        headers.forEach { k, v in
            request.setValue(v, forHTTPHeaderField: k)
        }
        
        if let params = queryParams {
            request.url = request.url?.applyingQueryParameters(params)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    callback(.failure(error))
                }
                return
            }
            
            guard
                let _httpResponse = response,
                let httpResponse = _httpResponse as? HTTPURLResponse,
                let data = data
            else {
                callback(.failure(NetworkingError.unknown))
                return
            }
            
            #if DEBUG
            print("HTTP Status Code: \(httpResponse.statusCode)")
            #endif
            
            if httpResponse.statusCode != 200 {
                DispatchQueue.main.async {
                    callback(.failure(NetworkingError.badRequest))
                }
                return
            }
            
            receivingQueue.async {
                do {
                    let responseObject = try JSONDecoder().decode(type, from: data)
                    callback(.success(responseObject))
                } catch let e {
                    callback(.failure(e))
                }
            }
        }
        .resume()
    }
    
    func make<T: Encodable, U: Decodable>(send some: T, expect type: U.Type, receiveOn receivingQueue: DispatchQueue = .main, callback: @escaping ResultCallback<U>) {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = method.value
        headers.forEach { k, v in
            request.setValue(v, forHTTPHeaderField: k)
        }
        
        if let params = queryParams {
            request.url = request.url?.applyingQueryParameters(params)
        }
        
        do {
            let encodedBody = try JSONEncoder().encode(some)
            request.httpBody = encodedBody
        } catch {
            callback(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    callback(.failure(error))
                }
                return
            }
            
            guard
                let _httpResponse = response,
                let httpResponse = _httpResponse as? HTTPURLResponse,
                let data = data
            else {
                callback(.failure(NetworkingError.unknown))
                return
            }
            
            #if DEBUG
            print("HTTP Status Code: \(httpResponse.statusCode)")
            #endif
            
            if !(200...299).contains(httpResponse.statusCode) {
                DispatchQueue.main.async {
                    callback(.failure(NetworkingError.badRequest))
                }
                return
            }
            
            receivingQueue.async {
                do {
                    let responseObject = try JSONDecoder().decode(type, from: data)
                    callback(.success(responseObject))
                } catch let e {
                    callback(.failure(e))
                }
            }
        }
    }
}

fileprivate extension URL {
    func applyingQueryParameters(_ params: [String: String]) -> URL {
        var newStr = absoluteString
        newStr.append("?")
        params.forEach { k, v in
            newStr.append("\(k)=\(v)&")
        }
        newStr.removeLast()
        
        guard let url = URL(string: newStr) else { fatalError() }
        return url
    }
}
