//
//  CodableError.swift
//  KitchenCatalogue
//
//  Created by iniad on 2019/05/19.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import Foundation

enum CodableError: Error {
    case encode(Codable)
    case decode(Codable)
}
