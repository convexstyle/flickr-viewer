//
//  MainView.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 23/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit
import FontAwesome_swift


/**
 The view of MainViewController
 */
class MainView: UIView {
  
  let imageCollectionView: UICollectionView
  let borderView: UIView
  let navCollectionView: UICollectionView
  let externalLinkButton: UIButton
  
  // MARK: - Life cycle
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    let imageLayout = UICollectionViewFlowLayout()
    imageLayout.scrollDirection = .horizontal
    imageCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: imageLayout)
    
    borderView = UIView()
    
    let navLayout = UICollectionViewFlowLayout()
    navLayout.scrollDirection = .horizontal
    navCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: navLayout)
    
    externalLinkButton = UIButton()
    
    super.init(frame: frame)
    
    initViews()
    initConstraints()
  }
  
}


// MARK: - Constrainable
extension MainView: Constrainable {
  func initViews() {
    backgroundColor = .appDarkGreyColor()
    
    borderView.backgroundColor = .appLightBlueColor()
    addSubview(borderView)
    
    imageCollectionView.backgroundColor = .appDarkGreyColor()
    addSubview(imageCollectionView)
    
    navCollectionView.backgroundColor = .appBlueColor()
    addSubview(navCollectionView)
    
    externalLinkButton.isHidden = true
    externalLinkButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
    externalLinkButton.setTitleColor(UIColor.white, for: UIControlState())
    externalLinkButton.setTitle(String.fontAwesomeIcon(name: .externalLink), for: .normal)
    borderView.addSubview(externalLinkButton)
  }
  
  func initConstraints() {
    let metrics = [
      "navHeight": 100,
      "borderHeight": 30,
      "paddingRight": 15
    ]
    
    let subviews = [
      "imageCollection": imageCollectionView,
      "border": borderView,
      "nav": navCollectionView,
      "button": externalLinkButton
    ]
    
    let subviewsConstraints: [String: NSLayoutFormatOptions] = [
      "|[imageCollection]|": [],
      "|[border]|": [],
      "|[nav]|": [],
      "[button]-(paddingRight)-|": [],
      "V:|[imageCollection][border(borderHeight)][nav(navHeight)]|": []
    ]

    activateConstraints(subviewsConstraints, withViews: subviews, metrics: metrics as [String : AnyObject])
    activateConstraints(
      [
        NSLayoutConstraint(item: externalLinkButton, attribute: .centerY, relatedBy: .equal, toItem: borderView, attribute: .centerY, multiplier: 1, constant: 2)
      ]
    )
  }
}
