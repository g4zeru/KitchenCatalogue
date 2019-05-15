//
//  ExtensionURL.swift
//  KitchenCatalogue
//
//  Created by iniad on 2019/04/25.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import Foundation

extension URL {
    public func parseQuery() -> [String: String?] {
        var query: [String: String?] = [:]
        guard let comp = URLComponents(string: self.absoluteString) else {
            return query
        }
        guard let items = comp.queryItems else {
            return query
        }
        for item in items {
            query[item.name] = item.value
        }
        return query
    }
    public func parsePath() -> String? {
        guard let comp = URLComponents(string: self.absoluteString) else {
            return self.absoluteString
        }
        
        return (comp.scheme ?? "") + "://" + (comp.host ?? "") + comp.path
    }
}
