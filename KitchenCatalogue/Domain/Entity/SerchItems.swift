//
//  SerchItems.swift
//  FurnitureViewer
//
//  Created by iniad on 2019/04/16.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import Foundation

struct SerchItems: Codable {
    let total: Int
    let totalPages: Int
    let items: [Item]
    private enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case items = "results"
    }
    init?(json: Data) {
        let decoder = JSONDecoder()
        do {
            self = try decoder.decode(SerchItems.self, from: json)
        } catch {
            debugLog(items: error)
            return nil
        }
    }
}
