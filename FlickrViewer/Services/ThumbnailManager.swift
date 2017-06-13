//
//  ThumbnailManager.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 24/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit

protocol ThumbnailManagerDelegate: class {
  /**
   Delegate method to notify the current selected NSIndexPath
   
   - parameter sender: ThumbnailManager instance
   - parameter path: Selected NSIndexPath
  */
  func cellDidSelect(_ sender: ThumbnailManager, path: IndexPath)
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
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.cellDidSelect(self, path: indexPath)
  }
}


// MARK: - UICollectionViewDataSource
extension ThumbnailManager: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Keys.thumbnailCellId, for: indexPath)

    if let cell = cell as? ThumbnailCollectionViewCell {
      configureThumbnailCellWithItem(cell, item: items[indexPath.row])
    }
    
    return cell
  }
  
  fileprivate func configureThumbnailCellWithItem(_ cell: ThumbnailCollectionViewCell, item: FlickrItem) {
    cell.imagePath = item.smallImage
  }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension ThumbnailManager: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.size.width / 4, height: collectionView.frame.size.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets.zero
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}
