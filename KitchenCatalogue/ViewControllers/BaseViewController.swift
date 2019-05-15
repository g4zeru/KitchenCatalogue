//
//  BaseViewController.swift
//  FurnitureViewer
//
//  Created by iniad on 2019/04/16.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    private let backgroundView: UIView = {
        let view = UIView()
        view.frame = UIScreen.main.bounds
        view.backgroundColor = UIColor.white
        return view
    }()
    
    override func loadView() {
        super.loadView()
        self.view = self.backgroundView
    }
}
