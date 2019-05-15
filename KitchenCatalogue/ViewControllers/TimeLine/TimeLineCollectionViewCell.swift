//
//  FeedItemCollectionViewCell.swift
//  FurnitureViewer
//
//  Created by iniad on 2019/04/16.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import Foundation
import UIKit

class TimeLineCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let cellShadowView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.3
        return view
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: UIFont.roundedMgenplus1cLight, size: 15)
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.shadowOpacity = 0.9
        label.layer.shadowRadius = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(item: Item) {
        self.imageView.image(url: item.urls.small, debugUrl: item.urls.thumb)
        self.userNameLabel.text = item.user?.username
    }
    
    private func setLayout() {
        self.contentView.addSubview(self.cellShadowView)
        self.cellShadowView.addSubview(self.imageView)
        self.cellShadowView.addSubview(self.userNameLabel)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        self.contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        self.contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        self.cellShadowView.translatesAutoresizingMaskIntoConstraints = false
        self.cellShadowView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.cellShadowView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.cellShadowView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.cellShadowView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.topAnchor.constraint(equalTo: self.cellShadowView.topAnchor).isActive = true
        self.imageView.leadingAnchor.constraint(equalTo: self.cellShadowView.leadingAnchor).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: self.cellShadowView.bottomAnchor).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: self.cellShadowView.trailingAnchor).isActive = true
        
        self.userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.userNameLabel.leadingAnchor.constraint(equalTo: self.cellShadowView.leadingAnchor, constant: 3).isActive = true
        self.userNameLabel.trailingAnchor.constraint(equalTo: self.cellShadowView.trailingAnchor, constant: 3).isActive = true
        self.userNameLabel.bottomAnchor.constraint(equalTo: self.cellShadowView.bottomAnchor, constant: -3).isActive = true
    }
}
