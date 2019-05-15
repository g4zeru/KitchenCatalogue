//
//  DebugP.swift
//  FurnitureViewer
//
//  Created by iniad on 2019/04/16.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import Foundation

public func testLog<T>(items: T?, file: String = #file, line: Int = #line) {
    if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
        debugLog(items: items, file: file, line: line)
    }
}

public func debugLog<T>(items: T?, file: String = #file, line: Int = #line) {
    guard let items = items else {
        print("nil at \((file as NSString).lastPathComponent), Line:\(line)")
        return
    }
    #if DEBUG
    print("\(items) at \((file as NSString).lastPathComponent), Line:\(line)")
    #endif
}
