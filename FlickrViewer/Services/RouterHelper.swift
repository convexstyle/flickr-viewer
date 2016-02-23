//
//  RouterHelper.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 24/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit

class RouterHelper {

  class func generateURLEncodedBody(parameters: [String: AnyObject]) -> NSData? {
    return createQueryStringWithParameters(parameters).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
  }
  
  class func createQueryStringWithParameters(parameters: [String: AnyObject]) -> NSString {
    var queries = [String]()
    
    for (key, value) in parameters {
      let query = "\(key)=\(value)"
      queries.append(query)
    }
    
    return queries.joinWithSeparator("&")
  }
  
}
