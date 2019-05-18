//
//  RequestError.swift
//  KitchenCatalogue
//
//  Created by iniad on 2019/05/18.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import Foundation

enum RequestError: Error {
    enum Element: String {
        case header
        case body
        case path
        case domain
        case query
    }
    case noneValue(Element)
    case encode(Element)
    case incorrctlyValue(Element)
}
