//
//  HTTPRequest.swift
//  Oriient√
//
//  Created by Eilon Krauthammer on 02/05/2021.
//

import Foundation

public protocol Endpoint {
    /// Base URL string, e.g. *https://google.com*
    var baseURLPath: String { get }
    /// Supplmentary path string, e.g. */user/profile*
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryParams: [String: String]? { get }
    
    var urlComponents: URLComponents { get }
}

public protocol DownloadEndpoint: Endpoint { }
extension DownloadEndpoint {
    public var method: HTTPMethod { .get }
    public var headers: [String : String]? { nil }
    public var queryParams: [String : String]? { nil }
}

public extension Endpoint {
    var urlComponents: URLComponents {
        var urlComponents = URLComponents(string: baseURLPath)!
        urlComponents.path = path
        return urlComponents
    }
}

open class HTTPClient<E: Endpoint> {
    public typealias ResultCallback<T> = (Result<T, Error>) -> Void
    
    public init() { }
    
    private func makeRequest(from endpoint: E, with body: AnyEncodable? = nil) throws -> URLRequest {
        var urlComponents = endpoint.urlComponents
        urlComponents.queryItems = endpoint.queryParams?.map { k, v in
            URLQueryItem(name: k, value: v)
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = endpoint.method.value
        endpoint.headers?.forEach { k, v in
            request.setValue(v, forHTTPHeaderField: k)
        }
        
        if let body = body {
            let encodedBody = try JSONEncoder().encode(body)
            request.httpBody = encodedBody
        }
        
        return request
    }
    
    private func process<T>(response: (item: T?, urlResponse: URLResponse?, error: Error?)) -> Result<T, Error> {
        if let error = response.error {
            return .failure(error)
        }
        
        guard
            let _httpResponse = response.urlResponse,
            let httpResponse = _httpResponse as? HTTPURLResponse,
            let item = response.item
        else {
            return .failure(NetworkingError.unknown)
        }
        
        #if DEBUG
        print("HTTP Status Code: \(httpResponse.statusCode)")
        #endif
        
        if !(200...299).contains(httpResponse.statusCode) {
            return .failure(NetworkingError.badRequest(httpResponse))
        }
        
        return .success(item)
    }
    
    private func decode<T: Decodable>(_ type: T.Type, from data: Data) -> Result<T, Error> {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(type, from: data)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: - Common expect & send requests
    
    open func request(_ endpoint: E, callback: @escaping ResultCallback<Data>) {
        do {
            let request = try makeRequest(from: endpoint)
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                guard let self = self else { return }
                let processResult = self.process(response: (data, response, error))
                DispatchQueue.main.async {
                    callback(processResult)
                }
            }
            .resume()
        } catch {
            // Likely an encoding error.
            callback(.failure(error))
        }
    }
    
    open func request<T: Decodable>(_ endpoint: E, expect type: T.Type, callback: @escaping ResultCallback<T>) {
        do {
            let request = try makeRequest(from: endpoint)
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                guard let self = self else { return }
                switch self.process(response: (data, response, error)) {
                case .failure(let error):
                    DispatchQueue.main.async {
                        callback(.failure(error))
                    }
                case .success(let data):
                    DispatchQueue.main.async {
                        let result = self.decode(type, from: data)
                        callback(result)
                    }
                }
            }
            .resume()
        } catch {
            // Likely an encoding error.
            callback(.failure(error))
        }
    }
    
    open func request<T: Encodable, U: Decodable>(_ endpoint: E, send object: T, expect type: U.Type, receiveOn receivingQueue: DispatchQueue = .main, callback: @escaping ResultCallback<U>) {
        do {
            let request = try makeRequest(from: endpoint, with: object.eraseToAnyEncodable())
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                guard let self = self else { return }
                switch self.process(response: (data, response, error)) {
                case .failure(let error):
                    DispatchQueue.main.async {
                        callback(.failure(error))
                    }
                case .success(let data):
                    DispatchQueue.main.async {
                        let result = self.decode(type, from: data)
                        callback(result)
                    }
                }
            }
            .resume()
        } catch {
            // Likely an encoding error.
            callback(.failure(error))
        }
    }
}

// MARK: - Download tasks

public extension HTTPClient {
    func download(from endpoint: E, storeAt destinationURL: URL?, callback: @escaping ResultCallback<Data>) {
        do {
            let request = try makeRequest(from: endpoint)
            let downloadTask = URLSession.shared.downloadTask(with: request) { [weak self] url, response, error in
                guard let self = self else { return }
                do {
                    let tempURL = try self.process(response: (url, response, error)).get()
                    let data = try Data(contentsOf: tempURL)
                    callback(.success(data))
                    
                    if let url = destinationURL {
                        try FileManager.default.moveItem(at: tempURL, to: url)
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        callback(.failure(error))
                    }
                }
            }
            
            downloadTask.resume()
            
        } catch {
            callback(.failure(error))
        }
    }
}

// MARK: - iOS 15 Concurrency API

@available(iOS 15, macOS 12, *)
public extension HTTPClient {
    private func process(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkingError.unknown
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkingError.badRequest(httpResponse)
        }
    }
    
    func request<U: Decodable>(_ endpoint: E, expect type: U.Type) async throws -> U {
        let request = try makeRequest(from: endpoint)
        let (data, response) = try await URLSession.shared.data(for: request)
        try process(response: response)
        let resultObject = try JSONDecoder().decode(type, from: data)
        return resultObject
    }
    
    func request<T: Encodable, U: Decodable>(_ endpoint: E, send object: T, expect type: U.Type) async throws -> U {
        let request = try makeRequest(from: endpoint, with: object.eraseToAnyEncodable())
        let (data, response) = try await URLSession.shared.data(for: request)
        try process(response: response)
        let resultObject = try JSONDecoder().decode(type, from: data)
        return resultObject
    }
    
    func download(from endpoint: E, storeAt destinationURL: URL?) async throws -> Data {
        let request = try makeRequest(from: endpoint)
        let (url, response) = try await URLSession.shared.download(for: request)
        try process(response: response)
        
        if let destinationURL = destinationURL {
            try FileManager.default.moveItem(at: url, to: destinationURL)
            return try Data(contentsOf: destinationURL)
        }
        
        return try Data(contentsOf: url)
    }
    
    func request<T: Decodable>(_ type: T.Type, from endpointURL: URL) async throws -> T? {
        let request = URLRequest(url: endpointURL)
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func regularOperation(_ completion: @escaping (Data?, Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(Data(), nil)
        }
    }
    
    private func request<T: Decodable>(_ type: T.Type) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            regularOperation { data, error in
                if let data = data, let obj = try? JSONDecoder().decode(type, from: data) {
                    continuation.resume(returning: obj)
                } else if let error = error {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
}
