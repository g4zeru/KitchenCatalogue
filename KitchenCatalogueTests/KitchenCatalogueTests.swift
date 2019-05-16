//
//  KitchenCatalogueTests.swift
//  KitchenCatalogueTests
//
//  Created by iniad on 2019/04/16.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import XCTest
@testable import KitchenCatalogue

class KitchenCatalogueTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchPhotos() {
        let model = Network.APIRequestModel(path: "photos", method: .get)
        let networkExpectation: XCTestExpectation? =
            self.expectation(description: "connect API")
        Network.shared.request(model: model) { (result) in
            defer {
                networkExpectation?.fulfill()
            }
            guard case .success(let json) = result else {
                XCTAssert(false)
                return
            }
            debugP(items: json)
            XCTAssert(true)
        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }

    func testParsePhotos() {
        let model = Network.APIRequestModel(path: "search/photos", method: .get, querys: ["per_page": "20", "query": "kitchen"])
        let networkExpectation: XCTestExpectation? =
            self.expectation(description: "connect API")
        Network.shared.request(model: model) { (result) in
            defer {
                networkExpectation?.fulfill()
            }
            guard case .success(let json) = result else {
                XCTAssert(false)
                return
            }
            debugP(items: json)
            let decoder = JSONDecoder()
            let items: SerchItems = try! decoder.decode(SerchItems.self, from: json!)
            XCTAssertEqual(items.items.count, 20)
        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    func testAuthURL() {
        let path = UnsplashAuth.url(keys: [.readUser, .writePhotos])
        debugP(items: path)
        
        debugP(items: path?.parseQuery())
        
        debugP(items: path?.parsePath())
        
        XCTAssert(true)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
