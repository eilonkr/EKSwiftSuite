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

public extension Endpoint {
    var urlComponents: URLComponents {
        var urlComponents = URLComponents(string: baseURLPath)!
        urlComponents.path = path
        return urlComponents
    }
}

open class HTTPClient<E: Endpoint> {
    public typealias ResultCallback<T> = (Result<T, Error>) -> Void
    
    private func makeRequest(from endpoint: E, with body: AnyEncodable? = nil) -> Result<URLRequest, Error> {
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
            do {
                let encodedBody = try JSONEncoder().encode(body)
                request.httpBody = encodedBody
                return .success(request)
            } catch {
                return .failure(error)
            }
        }
        
        return .success(request)
    }
    
    private func process(response: (data: Data?, urlResponse: URLResponse?, error: Error?)) -> Result<Data, Error> {
        if let error = response.error {
            return .failure(error)
        }
        
        guard
            let _httpResponse = response.urlResponse,
            let httpResponse = _httpResponse as? HTTPURLResponse,
            let data = response.data
        else {
            return .failure(NetworkingError.unknown)
        }
        
        #if DEBUG
        print("HTTP Status Code: \(httpResponse.statusCode)")
        #endif
        
        if !(200...299).contains(httpResponse.statusCode) {
            return .failure(NetworkingError.badRequest(httpResponse))
        }
        
        return .success(data)
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
            let request = try makeRequest(from: endpoint).get()
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
            let request = try makeRequest(from: endpoint).get()
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
    
    open func make<T: Encodable, U: Decodable>(_ endpoint: E, send object: T, expect type: U.Type, receiveOn receivingQueue: DispatchQueue = .main, callback: @escaping ResultCallback<U>) {
        do {
            let request = try makeRequest(from: endpoint, with: object.eraseToAnyEncodable()).get()
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

// MARK: - iOS 15 Concurrency API

@available(iOS 15, *)
public extension HTTPClient {
    func make<U: Decodable>(_ endpoint: E, expect type: U.Type) async throws -> U {
        var urlComponents = endpoint.urlComponents
        urlComponents.queryItems = endpoint.queryParams?.map { k, v in
            URLQueryItem(name: k, value: v)
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = endpoint.method.value
        endpoint.headers?.forEach { k, v in
            request.setValue(v, forHTTPHeaderField: k)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as! HTTPURLResponse
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkingError.badRequest(httpResponse)
        }
        
        let resultObject = try JSONDecoder().decode(type, from: data)
        return resultObject
    }
    
    func make<T: Encodable, U: Decodable>(_ endpoint: E, send object: T, expect decodable: U.Type) async throws -> U {
        var urlComponents = endpoint.urlComponents
        urlComponents.queryItems = endpoint.queryParams?.map { k, v in
            URLQueryItem(name: k, value: v)
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = endpoint.method.value
        endpoint.headers?.forEach { k, v in
            request.setValue(v, forHTTPHeaderField: k)
        }
        
        let encodedBody = try JSONEncoder().encode(object)
        request.httpBody = encodedBody
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkingError.badRequest()
        }
        
        let resultObject = try JSONDecoder().decode(decodable, from: data)
        return resultObject
    }
}
