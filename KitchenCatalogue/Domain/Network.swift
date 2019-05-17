//
//  Network.swift
//  FurnitureViewer
//
//  Created by iniad on 2019/04/16.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import Foundation

class Network {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    struct APIRequestModel {
        let path: String
        let method: HTTPMethod
        let querys: [String: String]
        let headers: [String: String]
        let parameters: [String: String]
        init(path: String, method: HTTPMethod, querys: [String: String] = [:], headers: [String: String] = [:], parameters: [String: String] = [:]) {
            self.path = path
            self.method = method
            self.querys = querys
            self.headers = headers
            self.parameters = parameters
        }
    }
    
    ///https://unsplash.com/documentation#public-actions
    static let clientID: String = "556a9cc2bac95d14f83721ef48dedba2e890bcceba04bdd9d505060df710d1bf"
    ///https://unsplash.com/documentation#location
    static let domain: String = "https://api.unsplash.com/"
    
    static let shared: Network = Network()
    
    private let cashePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
    private let timeoutInterval: TimeInterval = 20
    
    func request(model: APIRequestModel, completion: @escaping (Result<Data?, Error>) -> Void) {
        let request: URLRequest
        do {
            request = try self.generateURLRequest(model: model)
        } catch {
            completion(.failure(error))
            return
        }
        let task: URLSessionDataTask = generateSessionDataTask(request: request, completion: completion)
        task.resume()
    }
    
    private func generateSessionDataTask(request: URLRequest, completion: @escaping (Result<Data?, Error>)->Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                completion(.failure(NetworkErrorGenerator(error: error as NSError).generate()))
            }
            completion(.success(data))
        }
    }
    
    private func generateURLRequest(model: APIRequestModel) throws -> URLRequest {
        let url = try self.insertQuery(path: model.path, querys: model.querys)
        var request = URLRequest(url: url, cachePolicy: self.cashePolicy, timeoutInterval: self.timeoutInterval)
        request.httpMethod = model.method.rawValue
        self.insertHedder(request: &request, headers: model.headers)
        try self.insertParameter(request: &request, parameters: model.parameters)
        return request
    }
    
    private func insertHedder(request: inout URLRequest, headers: [String: String]) {
        ///https://unsplash.com/documentation#version
        request.addValue("v1", forHTTPHeaderField: "Accept-Version")
        ///https://unsplash.com/documentation#public-actions
        request.addValue("Client-ID \(Network.clientID)", forHTTPHeaderField: "Authorization")
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
    }
    
    private func insertParameter(request: inout URLRequest, parameters: [String: String]) throws -> Void {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.sortedKeys)
    }
    
    private func insertQuery(path: String, querys: [String: String]) throws -> URL {
        let pathInsertedQuery: String = Network.insertQuery(path: path, querys: querys)
        guard let url = URL(string: pathInsertedQuery) else {
            throw NSError(domain: "url is invalid", code: 0, userInfo: ["urs_strings": path])
        }
        return url
    }
    
    static func insertQuery(path: String, querys: [String: String]) -> String {
        if querys.isEmpty {
            return path
        }
        var path = path + "?"
        for (index, query) in querys.enumerated() {
            path += query.key + "=" + query.value
            if index < querys.count - 1 {
                path += "&"
            }
        }
        return path
    }
}
