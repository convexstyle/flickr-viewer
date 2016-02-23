//
//  ImageCollectionViewCell.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 24/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit
import SDWebImage

class ImageCollectionViewCell: UICollectionViewCell {
  
  let imageView: UIImageView
  
  var imagePath: String? {
    didSet {
      if let imagePath = imagePath {
        imageView.sd_setImageWithURL(NSURL(string: imagePath)!, completed: { (image, _, _, _) in
          self.imageView.image = image
          self.setNeedsLayout()
        })
      }
    }
  }
  
  // MARK: - Life cycle
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    imageView = UIImageView()
    
    super.init(frame: frame)
    
    initViews()
    initConstraints()
  }

}


// MARK: - Constrainable
extension ImageCollectionViewCell: Constrainable {
  func initViews() {
    imageView.clipsToBounds = true
    imageView.contentMode   = .ScaleAspectFill
    contentView.addSubview(imageView)
  }
  
  func initConstraints() {
    let subviews = [
      "image": imageView
    ]
    
    let subviewsConstraints: [String: NSLayoutFormatOptions] = [
      "|[image]|": [],
      "V:|[image]|": []
    ]
    
    activateConstraints(subviewsConstraints, withViews: subviews, metrics: nil)
  }
}
