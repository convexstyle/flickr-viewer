//
//  UIFont+AppFont.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 28/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit

/**
 UIFont extension to manage custom UIFonts for FlickrViewer. Manage frequent used fonts here.
 */
extension UIFont {
  class func appThinFontOfSize(_ size: CGFloat) -> UIFont? {
    return UIFont(name: AppFont.Thin.rawValue, size: size)
  }
  
  class func appLightFontOfSize(_ size: CGFloat) -> UIFont? {
    return UIFont(name: AppFont.Light.rawValue, size: size)
  }
  
  class func appFontOfSize(_ size: CGFloat) -> UIFont? {
    return UIFont(name: AppFont.Normal.rawValue, size: size)
  }
  
  class func appMediumFontOfSize(_ size: CGFloat) -> UIFont? {
    return UIFont(name: AppFont.Medium.rawValue, size: size)
  }
  
  class func appBoldFontOfSize(_ size: CGFloat) -> UIFont? {
    return UIFont(name: AppFont.Bold.rawValue, size: size)
  }
}
