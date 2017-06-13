//
//  AppColor.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 27/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

/**
 UIColor extension to add custom colors for FlickrViewer. Manage frequent used colors here.
 */
extension UIColor {
  class func appGreyColor() -> UIColor {
    return UIColor("#ebebeb")
  }
  
  class func appMidGreyColor() -> UIColor {
    return UIColor("#41475b")
  }
  
  class func appDarkGreyColor() -> UIColor {
    return UIColor("#242b40")
  }
  
  class func appBlueColor() -> UIColor {
    return UIColor("#2c5ea7")
  }
  
  class func appLightBlueColor() -> UIColor {
    return UIColor("#386dbc")
  }
  
  class func appPinkColor() -> UIColor {
     return UIColor("#ed1384")
  }
}
