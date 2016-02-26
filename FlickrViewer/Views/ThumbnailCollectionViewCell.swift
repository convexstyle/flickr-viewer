//
//  ThumbnailCollectionViewCell.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 24/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit
import FontAwesome_swift

class ThumbnailCollectionViewCell: UICollectionViewCell {
  
  let imageView: UIImageView
  let borderView: UIView
  let iconLabel: UILabel
  
  var imagePath: String? {
    didSet {
      if let imagePath = imagePath {
        self.imageView.image = nil
        self.imageView.alpha = 0
        
        // Animation and reset layout
        imageView.sd_setImageWithURL(NSURL(string: imagePath)!, completed: { (image, _, _, _) in
          self.imageView.image = image
          self.setNeedsLayout()
          
          UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.imageView.alpha = 1
          }, completion: { (success) in
              if success {
                
              }
          })
        })
      }
    }
  }
  
  override var selected: Bool {
    didSet {
      iconLabel.hidden = selected != true
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
    iconLabel = UILabel()
    
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
    borderView.layer.borderColor = UIColor.appBlueColor().CGColor
    borderView.layer.borderWidth = 6
    contentView.addSubview(borderView)
    
    iconLabel.hidden = true
    iconLabel.textColor = .whiteColor()
    iconLabel.font = .fontAwesomeOfSize(35)
    iconLabel.text = String.fontAwesomeIconWithName(.Eye)
    addSubview(iconLabel)
  }
  
  func initConstraints() {
    let subviews = [
      "image": imageView,
      "border": borderView,
      "icon": iconLabel,
    ]
    
    let subviewsConstraints: [String: NSLayoutFormatOptions] = [
      "|[image]|": [],
      "|[border]|": [],
      "V:|[image]|": [],
      "V:|[border]|": []
    ]
    
    activateConstraints(subviewsConstraints, withViews: subviews, metrics: nil)
    activateConstraints(
      [
        NSLayoutConstraint(item: iconLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -10),
        NSLayoutConstraint(item: iconLabel, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -5)
      ]
    )
    
  }
}