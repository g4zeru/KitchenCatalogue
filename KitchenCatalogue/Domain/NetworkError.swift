//
//  NetworkError.swift
//  KitchenCatalogue
//
//  Created by iniad on 2019/05/17.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case networkConnectionLost
    case timeout
    case undefined
}

class NetworkErrorGenerator {
    let error: NSError
    init(error: NSError) {
        self.error = error
    }
    
    func generate() -> NetworkError {
        if isNetworkConnectionLost() {
            return NetworkError.networkConnectionLost
        } else if isTimeout() {
            return NetworkError.timeout
        } else {
            return NetworkError.undefined
        }
    }
    
    private func isNetworkConnectionLost() -> Bool {
        return self.error.code == URLError.networkConnectionLost.rawValue
    }
    
    private func isTimeout() -> Bool {
        return self.error.code == URLError.timedOut.rawValue
    }
}
