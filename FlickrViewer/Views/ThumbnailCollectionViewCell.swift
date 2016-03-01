//
//  ThumbnailCollectionViewCell.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 24/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit
import FontAwesome_swift


/**
 Custom UICollectionView cell of thumbnail's UICollectionView.
 */
class ThumbnailCollectionViewCell: UICollectionViewCell {
  
  let imageView: UIImageView
  let borderView: UIView
  
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
  
  // MARK: - Override UIView methods
  override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    
    UIBezierPath.drawLine(
      1,
      lineCap: .Square,
      strokeColor: UIColor.appLightBlueColor(),
      startPoint: CGPoint(x: rect.minX + 0.5, y: rect.minY),
      endPoint: CGPoint(x: rect.minX + 0.5, y: rect.maxY)
    )
    
    UIBezierPath.drawLine(
      1,
      lineCap: .Square,
      strokeColor: UIColor.appLightBlueColor(),
      startPoint: CGPoint(x: rect.midX, y: rect.midY - 5),
      endPoint: CGPoint(x: rect.midX, y: rect.midY + 5)
    )
    
    UIBezierPath.drawLine(
      1,
      lineCap: .Square,
      strokeColor: UIColor.appLightBlueColor(),
      startPoint: CGPoint(x: rect.midX - 5, y: rect.midY),
      endPoint: CGPoint(x: rect.midX + 5, y: rect.midY)
    )
  }
}

extension ThumbnailCollectionViewCell: Constrainable {
  func initViews() {
    backgroundColor = .clearColor()
    
    imageView.clipsToBounds = true
    imageView.contentMode = .ScaleAspectFill
    contentView.addSubview(imageView)
    
    borderView.hidden = true
    borderView.backgroundColor = .appPinkColor()
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
      "V:|[image]|": []
    ]
    
    activateConstraints(subviewsConstraints, withViews: subviews, metrics: nil)
    activateConstraints(
      [
        NSLayoutConstraint(item: borderView, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: borderView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: 5)
      ]
    )
    
  }
}