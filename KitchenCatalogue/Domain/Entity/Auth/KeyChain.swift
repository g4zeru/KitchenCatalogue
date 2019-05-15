//
//  Keychain.swift
//  KitchenCatalogue
//
//  Created by iniad on 2019/05/14.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import Foundation

class KeyChain {
    private let tag: String = "haruevorun.KitchenCatalogue.key.token"
    private let account: String = "hig2eowk4d5alkjlk4ej7wsl2a23dkjflkjlwk"
    private let comment: String = "このKeyはアプリケーションのAPIアクセストークンです"
    
    public static let shared: KeyChain = KeyChain()
    
    private var baseQuery: [String: Any] {
        return [kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: self.account as CFString,
                kSecAttrService as String: self.tag as CFString,
                kSecAttrComment as String: self.comment as CFString,
                kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly]
    }
    
    private func query(key: String) throws -> [String: Any] {
        guard let encodedKey = key.encodeWithUTF8() else {
            throw NSError(domain: "failure encode Key", code: 0, userInfo: nil)
        }
        return query(encodedKey: encodedKey as CFData)
    }
    
    private func query(encodedKey: CFData) -> [String: Any] {
        var query = self.baseQuery
        query.updateValue(encodedKey, forKey: kSecValueData as String)
        return query
    }
    
    private func query() -> [String: Any] {
        var query = self.baseQuery
        query.updateValue(kCFBooleanTrue as Any, forKey: kSecReturnData as String)
        return query
    }
    
    func add(key: String) -> Bool {
        let query = try! self.query(key: key)
        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func update(key: String) -> Bool {
        let query = try! self.query(key: key)
        let status: OSStatus = SecItemUpdate(query as CFDictionary, [kSecValueData as String: key.encodeWithUTF8()] as CFDictionary)
        return status == errSecSuccess
    }
    
    func match(key: String) -> Bool {
        let query = try! self.query(key: key)
        return self.matchQuery(query: query)
    }
    
    func match() -> Bool {
        return self.matchQuery(query: query())
    }
    
    private func matchQuery(query: [String: Any]) -> Bool {
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            return false
        }
        return true
    }
}

fileprivate extension String {
    func encodeWithUTF8() -> Data? {
        return self.data(using: String.Encoding.utf8)
    }
}
