//
//  TimeLineDataStoreTests.swift
//  KitchenCatalogueTests
//
//  Created by iniad on 2019/05/16.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import XCTest
@testable import KitchenCatalogue

class TimeLineDataStoreTests: XCTestCase {
    private var dataStore: TimeLineDataStore = TimeLineDataStore(path: Network.domain + "search/photos", keyword: "kitchen", perItem: 20)
    var networkExpectation: XCTestExpectation?
    
    func testLimitIndex() {
        self.dataStore.updateRequestIndex(index: 2)
        XCTAssert(!self.dataStore.requestToUpdate())
    }
    
    func testFetchItems() {
        self.dataStore.delegate = self
        self.networkExpectation = self.expectation(description: "connect API")
        let isLoad = dataStore.requestToUpdate()
        testLog(items: isLoad)
        if isLoad {
            self.waitForExpectations(timeout: 10, handler: nil)
        } else {
            XCTAssert(false)
        }
    }
}

extension TimeLineDataStoreTests: TimeLineDataStoreDelegate {
    func update() {
        testLog(items: dataStore.items.count)
        testLog(items: dataStore.items[0])
        XCTAssertEqual(dataStore.items.count, dataStore.oldItems.count + 20)
        networkExpectation?.fulfill()
    }
    
    func decodingError(err: Error) {
        debugLog(items: err)
        XCTAssert(false)
        networkExpectation?.fulfill()
    }
    
    func notFoundNetworkResponce(err: Error) {
        debugLog(items: err)
        XCTAssert(false)
        networkExpectation?.fulfill()
    }
}
