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
        imageView.sd_setImage(with: URL(string: imagePath)!, completed: { (image, _, _, _) in
          self.imageView.image = image
          self.setNeedsLayout()
          
          UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.imageView.alpha = 1
          }, completion: { (success) in
              if success {
                
              }
          })
        })
      }
    }
  }
  
  override var isSelected: Bool {
    didSet {
      borderView.isHidden = isSelected != true
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
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    _ = UIBezierPath.drawLine(
      1,
      lineCap: .square,
      strokeColor: UIColor.appLightBlueColor(),
      startPoint: CGPoint(x: rect.minX + 0.5, y: rect.minY),
      endPoint: CGPoint(x: rect.minX + 0.5, y: rect.maxY)
    )
    
    _ = UIBezierPath.drawLine(
      1,
      lineCap: .square,
      strokeColor: UIColor.appLightBlueColor(),
      startPoint: CGPoint(x: rect.midX, y: rect.midY - 5),
      endPoint: CGPoint(x: rect.midX, y: rect.midY + 5)
    )
    
    _ = UIBezierPath.drawLine(
      1,
      lineCap: .square,
      strokeColor: UIColor.appLightBlueColor(),
      startPoint: CGPoint(x: rect.midX - 5, y: rect.midY),
      endPoint: CGPoint(x: rect.midX + 5, y: rect.midY)
    )
  }
}

extension ThumbnailCollectionViewCell: Constrainable {
  func initViews() {
    backgroundColor = .clear
    
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    contentView.addSubview(imageView)
    
    borderView.isHidden = true
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
        NSLayoutConstraint(item: borderView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: borderView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 5)
      ]
    )
    
  }
}
