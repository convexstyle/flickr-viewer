//
//  UIView+AutoLayout.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 23/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit

/**
 UIView extension to add snippet codes to activate and deactivate constraints.
 */
extension UIView {

  func activateConstraints(_ constraints: [NSLayoutConstraint]) {
    NSLayoutConstraint.activate(constraints)
  }
  
  func activateConstraints(_ constraints: [String:NSLayoutFormatOptions], withViews views: [String:AnyObject], metrics: [String:AnyObject]? = nil) {
    for (_, view) in views {
      (view as! UIView).translatesAutoresizingMaskIntoConstraints = false
    }
    for (constraint, options) in constraints {
      let layoutConstraint = NSLayoutConstraint.constraints(withVisualFormat: constraint, options: options, metrics: metrics, views: views)
      NSLayoutConstraint.activate(layoutConstraint)
    }
  }
  
  func deactivateConstraints(_ constraints: [NSLayoutConstraint]) {
    NSLayoutConstraint.deactivate(constraints)
  }

}
