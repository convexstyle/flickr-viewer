//
//  UIFont+Snippet.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 27/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit

extension UIFont {
  class func listFontNames() {
    let fontFamilyNames = UIFont.familyNames()
    for family in fontFamilyNames {
      for name in UIFont.fontNamesForFamilyName(family) {
        print(name, separator: "", terminator: "\r\n")
      }
    }
  }
}
