//
//  MainView.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 23/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit

class MainView: UIView {
  
  // MARK: - Life cycle
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    initViews()
    initConstraints()
  }
  
}

extension MainView: Constrainable {
  func initViews() {
    backgroundColor = UIColor.whiteColor()
  }
  
  func initConstraints() {
    
  }
}