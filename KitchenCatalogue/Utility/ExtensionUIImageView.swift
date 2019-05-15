//
//  ExtensionUIImage.swift
//  KitchenCatalogue
//
//  Created by iniad on 2019/04/18.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func image(url: URL?, debugUrl: URL? = nil) {
        let interval: TimeInterval = 5
        guard var url = url else {
            return
        }
        #if DEBUG
        if let debugUrl = debugUrl {
            url = debugUrl
        }
        #endif
        testLog(items: "start fetching.....\(url)")
        self.image = nil
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            guard let data = data else {
                debugLog(items: error)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + interval, execute: {
                    self?.image(url: url, debugUrl: debugUrl)
                })
                return
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                self?.image = UIImage(data: data)
            }
        }).resume()
    }
    
    func image(url: String?, debugUrl: String? = nil) {
        self.image(url: URL(string: url), debugUrl: URL(string: debugUrl))
    }
}
extension URL {
    fileprivate init?(string: String?) {
        guard let string = string else {
            return nil
        }
        self.init(string: string)
    }
}
