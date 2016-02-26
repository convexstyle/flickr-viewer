//
//  MainView.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 23/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit

class MainView: UIView {
  
  let imageCollectionView: UICollectionView
  let navCollectionView: UICollectionView
  
  // MARK: - Life cycle
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    let imageLayout = ImageCollectionViewFlowLayout()
    imageLayout.scrollDirection = .Horizontal
    imageCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: imageLayout)
    
    let navLayout = UICollectionViewFlowLayout()
    navLayout.scrollDirection = .Horizontal
    navCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: navLayout)
    
    super.init(frame: frame)
    
    initViews()
    initConstraints()
  }
  
}

extension MainView: Constrainable {
  func initViews() {
    backgroundColor = .appDarkGreyColor()
    
    imageCollectionView.backgroundColor = .appDarkGreyColor()
    addSubview(imageCollectionView)
    
    navCollectionView.backgroundColor = .appBlueColor()
    addSubview(navCollectionView)
  }
  
  func initConstraints() {
    let metrics = [
      "navHeight": 100
    ]
    
    let subviews = [
      "imageCollection": imageCollectionView,
      "nav": navCollectionView
    ]
    
    let subviewsConstraints: [String: NSLayoutFormatOptions] = [
      "|[imageCollection]|": [],
      "|[nav]|": [],
      "V:|[imageCollection][nav(navHeight)]|": []
    ]

    activateConstraints(subviewsConstraints, withViews: subviews, metrics: metrics)
  }
}