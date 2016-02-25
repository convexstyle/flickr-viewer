//
//  ThumbnailCollectionViewCell.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 24/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit

class ThumbnailCollectionViewCell: UICollectionViewCell {
  
  let imageView: UIImageView
  let borderView: UIView
  
  var imagePath: String? {
    didSet {
      if let imagePath = imagePath {
        // TODO: - Animation, cache, placeholder image
        imageView.sd_setImageWithURL(NSURL(string: imagePath)!, completed: { (image, _, _, _) in
          self.imageView.image = image
          self.setNeedsLayout()
        })
      }
    }
  }
  
  override var selected: Bool {
    didSet {
      borderView.hidden = selected != true
    }
  }
  
  // MARK: - Life cycle
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    imageView = UIImageView()
    borderView = UIView()
    
    super.init(frame: frame)
    
    initViews()
    initConstraints()
  }
  
}

extension ThumbnailCollectionViewCell: Constrainable {
  func initViews() {
    imageView.clipsToBounds = true
    imageView.contentMode = .ScaleAspectFill
    contentView.addSubview(imageView)
    
    borderView.hidden = true
    borderView.layer.borderColor = UIColor.redColor().CGColor
    borderView.layer.borderWidth = 3
    contentView.addSubview(borderView)
  }
  
  func initConstraints() {
    let subviews = [
      "image": imageView,
      "border": borderView
    ]
    
    let subviewsConstraints: [String: NSLayoutFormatOptions] = [
      "|[image]|": [],
      "|[border]|": [],
      "V:|[image]|": [],
      "V:|[border]|": []
    ]
    
    activateConstraints(subviewsConstraints, withViews: subviews, metrics: nil)
  }
}