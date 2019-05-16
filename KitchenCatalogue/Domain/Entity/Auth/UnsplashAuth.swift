//
//  UnsplashAuth.swift
//  KitchenCatalogue
//
//  Created by iniad on 2019/04/25.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import Foundation

public class UnsplashAuth {
    public enum RequestKey: String {
        case `public` = "public"
        case readUser = "read_user"
        case writeUser = "write_user"
        case readPhotos = "read_photos"
        case writePhotos = "write_photos"
        case writeLikes = "write_likes"
        case writeFollowers = "write_followers"
        case readCollections = "read_collections"
        case writeCollections = "write_collections"
    }
    
    public struct Token: Codable {
        let accessToken: String
        let tokenType: String
        fileprivate let scope: String
        var scopes: [RequestKey] {
            let scopesFromString = self.scope.components(separatedBy: " ")
            return scopesFromString.compactMap(RequestKey.init)
        }
        let createdAt: Int
        private enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAt = "created_at"
        }
        
        init?(json: Data) {
            let decoder = JSONDecoder()
            do {
                self = try decoder.decode(UnsplashAuth.Token.self, from: json)
            } catch {
                return nil
            }
        }
        
        init?(json: Data?) {
            guard let json = json else {
                return nil
            }
            self.init(json: json)
        }
    }
    
    public struct Key: Codable {
        let accessKey: String
        let secretKey: String
    }
    
    public static var sharedKey: UnsplashAuth.Key = UnsplashAuth.loadKey()!
    public static let shared = UnsplashAuth()
    
    private static let domain: String = "https://unsplash.com/oauth"
    private static let redirectURI: String = "https://haruevorun.com/"
    private var tokenURI: String {
        return UnsplashAuth.domain + "/token"
    }
    private var authURI: String {
        return UnsplashAuth.domain + "/authorize"
    }
    
    public var accessToken: String?
    
    private let keychain: KeyChain = KeyChain.shared
    
    public static func isMatchRedirectURI(uri: URL?) -> Bool {
        if let uri = uri {
            return isMatchRedirectURI(uri: uri)
        } else {
            return false
        }
    }
    
    public static func isMatchRedirectURI(uri: URL) -> Bool {
        return isMatchRedirectURI(uriStrings: uri.parsePath())
    }
    
    private static func isMatchRedirectURI(uriStrings: String?) -> Bool {
        guard let uriStrings = uriStrings else {
            return false
        }
        return uriStrings == redirectURI
    }
    
    public func generateAuthorizeFullPath(keys: [UnsplashAuth.RequestKey]) -> URL? {
        var path = UnsplashAuth.shared.authURI
        var query = String()
        for (index, key) in keys.enumerated() {
            defer {
                if index < keys.count - 1 {
                    query += "+"
                }
            }
            query += key.rawValue
        }
        return URL(string: Network.insertQuery(path: path, querys: ["client_id": UnsplashAuth.sharedKey.accessKey, "response_type": "code", "scope": query, "redirect_uri": UnsplashAuth.redirectURI]))
    }
    
    func fetchAndRegistToken(code: String, completion: @escaping (Result<UnsplashAuth.Token, Error>)->Void) {
        fetchToken(code: code) { (result) in
            guard case .success(let token) = result else {
                completion(result)
                return
            }
            if self.registKeyChain(token: token) {
                completion(result)
            } else {
                completion(.failure(NSError(domain: "failure regist Token", code: 0, userInfo: nil)))
            }
        }
    }
    
    func fetchToken(code: String, completion: @escaping (Result<UnsplashAuth.Token, Error>)->Void) {
        let querys: [String: String] = ["client_id": UnsplashAuth.sharedKey.accessKey,
                                        "client_secret": UnsplashAuth.sharedKey.secretKey,
                                        "redirect_uri": UnsplashAuth.redirectURI,
                                        "code": code,
                                        "grant_type": "authorization_code"]
        let path = Network.insertQuery(path: self.tokenURI, querys: querys)
        let model: Network.APIRequestModel = Network.APIRequestModel(path: path, method: .post)
        Network.shared.request(model: model) { (result) in
            switch result {
            case .success(let json):
                guard let token: UnsplashAuth.Token = UnsplashAuth.Token.init(json: json) else {
                    completion(.failure(NSError(domain: "failure parse Token", code: 0, userInfo: nil)))
                    return
                }
                completion(.success(token))
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func registKeyChain(token: Token) -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        let accessToken = token.accessToken
        if self.keychain.match(key: accessToken) {
            return self.keychain.update(key: accessToken)
        } else {
            return self.keychain.add(key: accessToken)
        }
        #endif
    }
    
    public func findTokenFromKeyChain() -> Bool {
        #if targetEnvironment(simulator)
        return false
        #else
        return self.keychain.match()
        #endif
    }
    
    private static func loadKey() -> Key? {
        var key: UnsplashAuth.Key?
        if let urls = Bundle.main.path(forResource: "UnsplashAPIKey", ofType:"plist" ) {
            do {
                let data  = try Data(contentsOf: URL(fileURLWithPath: urls))
                key = try PropertyListDecoder().decode(UnsplashAuth.Key.self, from: data)
            } catch let e {
                print("Failed to getting properties from plist.")
                print("Reason: \(e)")
            }
        }
        return key
    }
}
