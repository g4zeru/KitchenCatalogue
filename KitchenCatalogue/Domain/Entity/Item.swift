//
//  Item.swift
//  FurnitureViewer
//
//  Created by iniad on 2019/04/16.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import Foundation

struct Item: Codable {
    struct Location: Codable {
        let city: String?
        let country: String?
    }
    
    struct Tag: Codable {
        let title: String?
    }
    
    struct URLs: Codable {
        let raw: URL?
        let full: URL?
        let regular: URL?
        let small: URL?
        let thumb: URL?
    }
    
    let id: String
    let createdAt: String
    let updatedAt: String
    let width: Float
    let height: Float
    let color: String
    let description: String?
    let location: Location?
    let tags: [Tag]?
    let user: User?
    let urls: URLs
    
    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width
        case height
        case color
        case description
        case location
        case tags
        case user
        case urls
    }
}
