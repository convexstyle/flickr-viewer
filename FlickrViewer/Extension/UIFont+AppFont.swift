//
//  UIFont+AppFont.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 28/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit

extension UIFont {
  class func appThinFontOfSize(size: CGFloat) -> UIFont? {
    return UIFont(name: AppFont.Thin.rawValue, size: size)
  }
  
  class func appLightFontOfSize(size: CGFloat) -> UIFont? {
    return UIFont(name: AppFont.Light.rawValue, size: size)
  }
  
  class func appFontOfSize(size: CGFloat) -> UIFont? {
    return UIFont(name: AppFont.Normal.rawValue, size: size)
  }
  
  class func appMediumFontOfSize(size: CGFloat) -> UIFont? {
    return UIFont(name: AppFont.Medium.rawValue, size: size)
  }
  
  class func appBoldFontOfSize(size: CGFloat) -> UIFont? {
    return UIFont(name: AppFont.Bold.rawValue, size: size)
  }
}
