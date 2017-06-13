//
//  ImageCollectionViewCell.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 24/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit
import SDWebImage

/**
 Custom UICollectionView cell of Full image's UICollectionView.
 */
class ImageCollectionViewCell: UICollectionViewCell {
  
  let imageView: UIImageView
  
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

  
  // MARK: - Override UIView methods
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    let blueCircle = UIBezierPath.drawCircle(
      1.0,
      lineCapStyle: CGLineCap.round,
      radius: 10,
      center: CGPoint(x: rect.midX - 15, y: rect.midY),
      startAngle: 0,
      endAngle: CGFloat(Double.pi * 4),
      clockwise: true
    )
    UIColor.appBlueColor().setFill()
    blueCircle.fill()
    blueCircle.close()
    
    let pinkCircle = UIBezierPath.drawCircle(
      1.0,
      lineCapStyle: CGLineCap.round,
      radius: 10,
      center: CGPoint(x: rect.midX + 15, y: rect.midY),
      startAngle: 0,
      endAngle: CGFloat(Double.pi * 4),
      clockwise: true
    )
    UIColor.appPinkColor().setFill()
    pinkCircle.fill()
    pinkCircle.close()
    
  }
  
}


// MARK: - Constrainable
extension ImageCollectionViewCell: Constrainable {
  func initViews() {
    backgroundColor = .clear
    
    imageView.clipsToBounds = true
    imageView.contentMode   = .scaleAspectFill
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
