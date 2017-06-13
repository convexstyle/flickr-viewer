//
//  Router.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 23/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import Foundation
import Alamofire

/**
 Manage router information for any Flickr API call.
 */
enum Router: URLRequestConvertible {
  
  static let baseURLString = "https://api.flickr.com/services/"
  
  case publicFeed
  
  func asURLRequest() throws -> URLRequest {
    let result: (path: String, parameters: Parameters) = {
      switch self {
      case .publicFeed:
        return ("feeds/photos_public.gne", ["format": "json", "nojsoncallback": "1"])
      }
    }()
    
    let method: HTTPMethod = {
      switch self {
      case .publicFeed:
        return .get
      }
    }()
    
    let url               = try Router.baseURLString.asURL()
    var urlRequest        = URLRequest(url: url.appendingPathComponent(result.path))
    urlRequest.httpMethod = method.rawValue
    
    return try URLEncoding.default.encode(urlRequest, with: result.parameters)
  }
}
