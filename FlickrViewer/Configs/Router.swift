//
//  Router.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 23/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit
import Alamofire

enum Router: URLRequestConvertible {

  static let baseURLString = "https://api.flickr.com/services/"
  
  case PublicFeed([String: AnyObject])
  
  var method: Alamofire.Method {
    switch self {
    case .PublicFeed(_):
      return .GET
    }
  }
  
  var path: String {
    switch self {
    case .PublicFeed(_):
      return "feeds/photos_public.gne"
    }
  }
  
  var URLRequest: NSMutableURLRequest {
    let URL = NSURL(string: Router.baseURLString)!
    let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
    mutableURLRequest.HTTPMethod = method.rawValue
    
    switch self {
    case .PublicFeed(let parameters):
      mutableURLRequest.addValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
      mutableURLRequest.HTTPBody = RouterHelper.generateURLEncodedBody(parameters)
      return mutableURLRequest
    }
  }
  
}
