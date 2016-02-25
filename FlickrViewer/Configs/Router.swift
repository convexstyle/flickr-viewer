//
//  Router.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 23/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import Foundation
import Alamofire

enum Router: String {
  
  static let baseURLString = "https://api.flickr.com/services/"
  
  case PublicFeed = "feeds/photos_public.gne"
  
  var method: Alamofire.Method {
    switch self {
    case .PublicFeed:
      return .GET
    }
  }
  
  var parameters: [String: AnyObject]? {
    switch self {
    case .PublicFeed:
      return [
        "format": "json",
        "nojsoncallback": "1"
      ]
    }
  }
  
  var URL: NSURL {
    switch self {
    case .PublicFeed:
      return NSURL(string: Router.baseURLString)!.URLByAppendingPathComponent(self.rawValue)
    }
  }
}
