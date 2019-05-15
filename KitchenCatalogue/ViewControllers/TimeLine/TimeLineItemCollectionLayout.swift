//
//  FeedItemCollectionLayout.swift
//  FurnitureViewer
//
//  Created by iniad on 2019/04/17.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import Foundation
import UIKit

protocol TimeLineCollectionLayoutDelegate: class {
    func prepareHeight(collectionView: UICollectionView?, indexPath: IndexPath, widthSize: CGFloat) -> CGFloat
}

class TimeLineCollectionLayout: UICollectionViewLayout {
    
    weak var delegate: TimeLineCollectionLayoutDelegate?
    
    var numColumns = 2
    var padding: CGFloat = 10
    var attributesArray = [UICollectionViewLayoutAttributes]()
    var contentHeight: CGFloat = 0
    
    var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.bounds.width
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        let columnWidth = contentWidth / CGFloat(numColumns)
        var xOffsets = [CGFloat]()
        for column in 0..<numColumns {
            xOffsets.append(columnWidth * CGFloat(column))
        }
        
        var column = 0
        var yOffsets = [CGFloat](repeating: 0, count: numColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let itemHeight = delegate!.prepareHeight(collectionView: collectionView, indexPath: indexPath, widthSize: columnWidth)
            let height = itemHeight + padding * 2
            let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: padding, dy: padding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            attributesArray.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffsets[column] = yOffsets[column] + height
            
            column = column < (numColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in attributesArray {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
}
