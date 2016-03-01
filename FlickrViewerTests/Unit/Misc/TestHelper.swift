//
//  TestHelper.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 28/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import Quick
import Nimble

func fixtureDataFromFile(name: String, ofType type: String = "json") -> NSData? {
  let bundle = NSBundle(identifier: "com.convexstyle.FlickrViewerTests")!
  let pathForFixture = bundle.pathForResource(name, ofType: type)!
  
  return NSData(contentsOfFile: pathForFixture)
}

func fixtureStringFromFile(name: String, ofType type: String = "json") -> String? {
  let data = fixtureDataFromFile(name, ofType: type)
  
  if let data = data {
    return NSString(data: data, encoding: NSUTF8StringEncoding) as? String
  }
  
  return nil
}

func stringToData(string: String) -> NSData? {
  return NSString(string: string).dataUsingEncoding(NSUTF8StringEncoding)
}

func createQueryStringWithParameters(parameters: [String: AnyObject]?) -> String {
  guard let parameters = parameters else {
    return ""
  }
  
  var queries = [String]()
  
  for (key, value) in parameters {
    let query = "\(key)=\(value)"
    queries.append(query)
  }
  
  return queries.joinWithSeparator("&")
}