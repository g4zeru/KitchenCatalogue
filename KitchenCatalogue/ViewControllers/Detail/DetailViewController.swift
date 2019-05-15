//
//  DetailViewController.swift
//  FurnitureViewer
//
//  Created by iniad on 2019/04/17.
//  Copyright © 2019 harutaYamada. All rights reserved.
//
import Foundation
import UIKit

class DetailViewController: BaseViewController {
    var item: Item?
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    private var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    private var descriptionView: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont(name: UIFont.roundedMgenplus1cLight, size: 17)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    private var separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    private var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        return imageView
    }()
    
    private var iconShadowView: UIView = {
        let view = UIView()
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        return view
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont(name: UIFont.roundedMgenplus1cMedium, size: 20)
        return label
    }()
    
    private var usernameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont(name: UIFont.roundedMgenplus1cThin, size: 17)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    private var secondSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Detail"
        
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.descriptionView)
        self.contentView.addSubview(self.separator)
        self.contentView.addSubview(self.iconShadowView)
        self.iconShadowView.addSubview(self.iconView)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.usernameLabel)
        self.contentView.addSubview(self.secondSeparator)
        
        self.setupLayout()
        self.setItem()
    }
    
    private func setupLayout() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20).isActive = true
        self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        self.imageView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: self.imageViewHeight()).isActive = true
        
        self.descriptionView.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 10).isActive = true
        self.descriptionView.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor).isActive = true
        self.descriptionView.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor).isActive = true
        
        self.separator.translatesAutoresizingMaskIntoConstraints = false
        self.separator.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
        self.separator.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        self.separator.topAnchor.constraint(equalTo: self.descriptionView.bottomAnchor, constant: 10).isActive = true
        self.separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.iconShadowView.translatesAutoresizingMaskIntoConstraints = false
        self.iconShadowView.topAnchor.constraint(equalTo: self.separator.bottomAnchor, constant: 20).isActive = true
        self.iconShadowView.leadingAnchor.constraint(equalTo: self.separator.leadingAnchor).isActive = true
        self.iconShadowView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, multiplier: 0.15).isActive = true
        self.iconShadowView.heightAnchor.constraint(equalTo: self.iconView.widthAnchor).isActive = true
        
        self.iconView.translatesAutoresizingMaskIntoConstraints = false
        self.iconView.topAnchor.constraint(equalTo: self.iconShadowView.topAnchor).isActive = true
        self.iconView.leadingAnchor.constraint(equalTo: self.iconShadowView.leadingAnchor).isActive = true
        self.iconView.bottomAnchor.constraint(equalTo: self.iconShadowView.bottomAnchor).isActive = true
        self.iconView.trailingAnchor.constraint(equalTo: self.iconShadowView.trailingAnchor).isActive = true
        
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.nameLabel.leadingAnchor.constraint(equalTo: self.iconView.trailingAnchor, constant: 30).isActive = true
        self.nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 20).isActive = true
        self.nameLabel.centerYAnchor.constraint(equalTo: self.iconView.centerYAnchor, constant: -10).isActive = true
        
        self.usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.usernameLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 1).isActive = true
        self.usernameLabel.leadingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor).isActive = true
        self.usernameLabel.trailingAnchor.constraint(equalTo: self.nameLabel.trailingAnchor).isActive = true
        
        self.secondSeparator.translatesAutoresizingMaskIntoConstraints = false
        self.secondSeparator.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
        self.secondSeparator.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        self.secondSeparator.topAnchor.constraint(equalTo: self.iconShadowView.bottomAnchor, constant: 30).isActive = true
        self.secondSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.secondSeparator.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    private func imageViewHeight() -> CGFloat {
        let width = self.view.frame.width - 40
        let rate = width / CGFloat(item?.width ?? 1)
        return CGFloat(item?.height ?? 1) * rate
    }
    
    private func setItem() {
        self.descriptionView.text = self.item?.description
        
        self.nameLabel.text = self.item?.user?.name
        self.usernameLabel.text = self.item?.user?.username
        
        self.imageView.image(url: self.item?.urls.full, debugUrl: self.item?.urls.thumb)
        self.iconView.image(url: self.item?.user?.profileImage?.medium, debugUrl: self.item?.user?.profileImage?.small)
    }
}
