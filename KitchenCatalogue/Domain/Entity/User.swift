//
//  User.swift
//  FurnitureViewer
//
//  Created by iniad on 2019/04/16.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import Foundation

struct User: Codable {
    struct URLs: Codable {
        let small: URL?
        let medium: URL?
        let large: URL?
    }
    
    let id: String
    let updatedAt: String
    let username: String
    let name: String
    let portfolioUrl: URL?
    let bio: String?
    let location: String?
    let profileImage: URLs?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case updatedAt = "updated_at"
        case username
        case name
        case portfolioUrl = "portfolio_url"
        case bio
        case location
        case profileImage = "profile_image"
    }
}
