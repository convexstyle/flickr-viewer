//
//  FlickrJsonParser.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 26/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import Foundation
import SwiftyJSON


class FlickrJsonParser {
  class func parseJson(data: NSData) -> [FlickrItem]? {
    var flickrItems: [FlickrItem]?
    
    let json = JSON(data: data)
    
    guard let items = json["items"].array else {
      return nil
    }
    
    flickrItems = [FlickrItem]()
    
    for item in items {
      let link = item["link"].string
      let mediumImageURL = item["media"]["m"].string
      
      if let mediumImageURL = mediumImageURL {
        let slugImageURL = FlickrJsonParser.getSlugImagePath(mediumImageURL)
        
        var item = FlickrItem()
        item.originalImage = "\(slugImageURL).jpg"
        item.mediumImage = mediumImageURL
        item.thumbnailImage = "\(slugImageURL)_t.jpg"
        item.smallImage = "\(slugImageURL)_s.jpg"
        item.link = link
        
        flickrItems?.append(item)
      }
      
    }
    
    return flickrItems
  }
  
  
  class func removeBackSlashesFromEspcapedSingleQuotes(str: String) -> String {
    return str.stringByReplacingOccurrencesOfString("\\'", withString: "'")
  }
  
  class func getSlugImagePath(imageURL: String) -> String {
    let pattern = "(https:\\/\\/.*)_m\\.jpg"
    return imageURL.stringByReplacingOccurrencesOfString(pattern, withString: "$1", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
  }
  
  
  class func createQueryStringWithParameters(parameters: [String: AnyObject]?) -> String {
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
}
