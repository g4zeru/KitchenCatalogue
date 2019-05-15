//
//  ViewController.swift
//  FurnitureViewer
//
//  Created by iniad on 2019/04/16.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import UIKit

class TimeLineViewController: BaseViewController {
    private var items: [Item] = [] {
        didSet(oldvalue) {
            updateCollection(item: self.items, oldItem: oldvalue)
        }
    }
    
    private let network = Network.shared
    private let keyword = "kitchen"

    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(TimeLineCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    private var requestIndex: Int = 0
    private var limitIndex: Int = 1
    private var canLoad: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
        
        self.canLoad = true
        self.load()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        testLog(items: "token: " + String(describing: UnsplashAuth.shared.accessToken))
    }
    
    private func setupLayout() {
        self.navigationItem.title = "TimeLine"
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: UIFont.roundedMgenplus1cMedium, size: 24)!]
        
        self.view.addSubview(self.collectionView)
        
        let layout = TimeLineCollectionLayout()
        layout.delegate = self
        
        self.collectionView.collectionViewLayout = layout
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.collectionView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.collectionView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.collectionView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    func load() {
        self.canLoad = false
        guard self.requestIndex < self.limitIndex else {
            return
        }
        self.requestIndex += 1
        let model = Network.APIRequestModel(path: Network.domain + "search/photos", method: .get, querys: ["page": String(self.requestIndex),"per_page": "20", "query": self.keyword])
        network.request(model: model) { [weak self] (result) in
            switch result {
            case .success(let json):
                guard let unwrapJson = json else {
                    debugLog(items: "json data is nil")
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let items: SerchItems = try decoder.decode(SerchItems.self, from: unwrapJson)
                    self?.limitIndex = items.totalPages
                    self?.items.append(contentsOf: items.items)
                } catch {
                    debugLog(items: "error: \(error)")
                    return
                }
                testLog(items: "requestIndex: \(String(describing: self?.requestIndex))")
                testLog(items: "limitIndex: \(String(describing: self?.limitIndex))")
            case .failure(let error):
                debugLog(items: "error: \(error)")
            }
        }
    }
}

extension TimeLineViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TimeLineCollectionViewCell
        cell.set(item: items[indexPath.item])
        return cell
    }
}

extension TimeLineViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let item = self.items[indexPath.item]
        let viewController = DetailViewController()
        
        viewController.item = item
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.contentSize.height
        let yOffset = scrollView.contentOffset.y + scrollView.frame.height
        let bottom = height - yOffset
        
        if bottom <= self.view.frame.height * 0.4 && canLoad == true {
            load()
        }
    }
}

extension TimeLineViewController: TimeLineCollectionLayoutDelegate {
    func prepareHeight(collectionView: UICollectionView?, indexPath: IndexPath, widthSize: CGFloat) -> CGFloat {
        return widthSize / CGFloat(items[indexPath.item].width) * CGFloat(items[indexPath.item].height)
    }
    
    private func updateCollection(item: [Item], oldItem: [Item]) {
        DispatchQueue.main.async {
            if oldItem.count < self.items.count {
                self.collectionView.performBatchUpdates({
                    var paths: [IndexPath] = []
                    for i in oldItem.count...(self.items.count - 1) {
                        paths.append(IndexPath(item: i, section: 0))
                    }
                    self.collectionView.insertItems(at: paths)
                }, completion: { (completion) in
                    self.canLoad = true
                })
            } else {
                self.collectionView.reloadData()
            }
        }
    }
}
