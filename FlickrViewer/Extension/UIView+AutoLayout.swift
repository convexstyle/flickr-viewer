//
//  UIView+AutoLayout.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 23/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit

extension UIView {

  func activateConstraints(constraints: [NSLayoutConstraint]) {
    NSLayoutConstraint.activateConstraints(constraints)
  }
  
  func activateConstraints(constraints: [String:NSLayoutFormatOptions], withViews views: [String:AnyObject], metrics: [String:AnyObject]? = nil) {
    for (_, view) in views {
      (view as! UIView).translatesAutoresizingMaskIntoConstraints = false
    }
    for (constraint, options) in constraints {
      let layoutConstraint = NSLayoutConstraint.constraintsWithVisualFormat(constraint, options: options, metrics: metrics, views: views)
      NSLayoutConstraint.activateConstraints(layoutConstraint)
    }
  }
  
  func deactivateConstraints(constraints: [NSLayoutConstraint]) {
    NSLayoutConstraint.deactivateConstraints(constraints)
  }

}
