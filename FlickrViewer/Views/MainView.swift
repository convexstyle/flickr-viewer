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
  let borderView: UIView
  let navCollectionView: UICollectionView
  
  // MARK: - Life cycle
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    let imageLayout = UICollectionViewFlowLayout()
    imageLayout.scrollDirection = .Horizontal
    imageCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: imageLayout)
    
    borderView = UIView()
    
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
    
    borderView.backgroundColor = .appLightBlueColor()
    addSubview(borderView)
    
    imageCollectionView.backgroundColor = .appDarkGreyColor()
    addSubview(imageCollectionView)
    
    navCollectionView.backgroundColor = .appBlueColor()
    addSubview(navCollectionView)
  }
  
  func initConstraints() {
    let metrics = [
      "navHeight": 100,
      "borderHeight": 8
    ]
    
    let subviews = [
      "imageCollection": imageCollectionView,
      "border": borderView,
      "nav": navCollectionView
    ]
    
    let subviewsConstraints: [String: NSLayoutFormatOptions] = [
      "|[imageCollection]|": [],
      "|[border]|": [],
      "|[nav]|": [],
      "V:|[imageCollection][border(borderHeight)][nav(navHeight)]|": []
    ]

    activateConstraints(subviewsConstraints, withViews: subviews, metrics: metrics)
  }
}