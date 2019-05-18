//
//  TimeLineDataStore.swift
//  KitchenCatalogue
//
//  Created by iniad on 2019/05/16.
//  Copyright © 2019 harutaYamada. All rights reserved.
//
import Foundation

protocol TimeLineDataStoreDelegate: class {
    func update()
    func decodingError(err: Error)
    func notFoundNetworkResponce(err: Error)
}

class TimeLineDataStore {
    private(set) var items: [Item] {
        didSet(oldvalue) {
            self.oldItems = oldvalue
        }
    }
    private(set) var oldItems: [Item]
    let path: String
    let keyword: String
    private let perItem: Int
    private(set) var isRequest: Bool
    private(set) var requestIndex: Int
    private(set) var limitIndex: Int
    private var network: Network?
    weak var delegate: TimeLineDataStoreDelegate?
    
    init(path: String, keyword: String, perItem: Int = 10) {
        self.path = path
        self.keyword = keyword
        self.perItem = perItem
        self.items = []
        self.oldItems = []
        self.isRequest = false
        self.requestIndex = 0
        self.limitIndex = 0
    }
    
    func canNextLoad(isRequest: Bool) -> Bool {
        return self.requestIndex <= self.limitIndex && !isRequest
    }
    
    @discardableResult
    func requestToUpdate() -> Bool {
        guard canNextLoad(isRequest: self.isRequest) else {
            return false
        }
        self.isRequest = true
        self.countUpIndex()
        self.fetchItemsAndFlagToUpdate()
        return true
    }
    
    func fetchItemsAndFlagToUpdate() {
        let model = Network.APIRequestModel(path: self.path, method: .get, querys: ["page": String(self.requestIndex),"per_page": String(perItem), "query": self.keyword])
        self.network = Network(requestModel: model)
        network?.request() { [weak self] (result) in
            self?.assignResponce(responce: result)
        }
    }
    
    func assignResponce(responce: Result<Data?, Error>) {
        switch responce {
        case .success(let json):
            defer {
                self.countUpIndex()
                self.isRequest = false
            }
            self.decodeAndFlagToUpdate(json: json)
        case .failure(let error):
            self.delegate?.notFoundNetworkResponce(err: error)
        }
    }
    
    func decodeAndFlagToUpdate(json: Data?) {
        do {
            let (items, limitIndex) = try decodeToArrayOfItemsAndLimitIndex(json: json)
            appendItems(items: items)
            updateLimitIndex(index: limitIndex)
            self.delegate?.update()
        } catch {
            self.delegate?.decodingError(err: error)
        }
    }
    
    func decodeToArrayOfItemsAndLimitIndex(json: Data?) throws -> ([Item], Int) {
        let items: SerchItems = try decodeSerchItems(json: json)
        return (items.items, items.totalPages)
    }
    
    func convertToArrayOfItems(item: SerchItems) -> [Item] {
        return item.items
    }
    
    func decodeSerchItems(json: Data?) throws -> SerchItems {
        guard let json = json else {
            throw NSError(domain: "json is nil", code: 0, userInfo: nil)
        }
        return try decodeSerchItems(json: json)
    }
    
    func decodeSerchItems(json: Data) throws -> SerchItems {
        let decoder = JSONDecoder()
        var serchItems: SerchItems?
        serchItems = try decoder.decode(SerchItems.self, from: json)
        guard serchItems != nil else {
            throw NSError(domain: "SerchItems is nil", code: 0, userInfo: nil)
        }
        return serchItems!
    }
    
    private func appendItems(items: [Item]) {
        self.items.append(contentsOf: items)
    }
    
    private func countUpIndex() {
        self.requestIndex += 1
    }
    
    private func updateLimitIndex(index: Int) {
        self.limitIndex = index
    }
    
    func updateRequestIndex(index: Int) {
        self.requestIndex = index
    }
}
