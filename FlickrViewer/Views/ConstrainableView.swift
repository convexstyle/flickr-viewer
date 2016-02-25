//
//  ConstrainableView.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 23/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit


// MARK: - Constrainable
protocol Constrainable {
  func initViews() -> Void
  func initConstraints() -> Void
}


// MARK: - ConstrainableView
class ConstrainableView: UIView {
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  override func willMoveToSuperview(newSuperview: UIView?) {
    super.willMoveToSuperview(newSuperview)
    
    initViews()
    initConstraints()
  }
  
}

extension ConstrainableView: Constrainable {
  
  func initViews() {}
  
  func initConstraints() {}
  
}
