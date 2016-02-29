//
//  ThumbnailManager.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 24/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit

protocol ThumbnailManagerDelegate: class {
  func cellDidSelect(sender: ThumbnailManager, path: NSIndexPath)
}

/**
 Helper class to manage UICollectionViewDelegate and UICollectionViewDataSource of thumbnail's UICollectionView.
 */
class ThumbnailManager: NSObject {

  struct Constants {
    struct Keys {
      static let thumbnailCellId = "ThumbnailManager.thumbnailCellId"
    }
  }
  
  weak var delegate: ThumbnailManagerDelegate?
  weak var collectionView: UICollectionView?
  
  var items = [FlickrItem]() {
    didSet {
      collectionView?.reloadData()
    }
  }
}


// MARK: - UICollectionViewDelegate
extension ThumbnailManager: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    delegate?.cellDidSelect(self, path: indexPath)
  }
}


// MARK: - UICollectionViewDataSource
extension ThumbnailManager: UICollectionViewDataSource {
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.Keys.thumbnailCellId, forIndexPath: indexPath)

    if let cell = cell as? ThumbnailCollectionViewCell {
      configureThumbnailCellWithItem(cell, item: items[indexPath.row])
    }
    
    return cell
  }
  
  private func configureThumbnailCellWithItem(cell: ThumbnailCollectionViewCell, item: FlickrItem) {
    cell.imagePath = item.smallImage
  }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension ThumbnailManager: UICollectionViewDelegateFlowLayout {
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.size.width / 4, height: collectionView.frame.size.height)
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    return UIEdgeInsetsZero
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 0
  }
}