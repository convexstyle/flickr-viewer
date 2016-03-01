//
//  PhotoItem.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 24/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import Foundation
import SwiftyJSON

/**
 Flickr data object store necessary fields
 */
//struct FlickrItem {
//  var originalImage: String?
//  var mediumImage: String?
//  var smallImage: String?
//  var thumbnailImage: String?
//  var link: String?
//}

 /**
 Flickr data object to store necessary fields
 */
class FlickrItem {
  let item: JSON
  
  var originalImage: String? {
    guard let mediumImage = mediumImage else {
      return nil
    }
    
    return "\(FlickrJsonParser.getSlugImagePath(mediumImage)).jpg"
  }
  
  var mediumImage: String? {
    return item["media"]["m"].string
  }
  
  var smallImage: String? {
    guard let mediumImage = mediumImage else {
      return nil
    }
    
    return "\(FlickrJsonParser.getSlugImagePath(mediumImage))_s.jpg"
  }
  
  var thumbnailImage: String? {
    guard let mediumImage = mediumImage else {
      return nil
    }
    
    return "\(FlickrJsonParser.getSlugImagePath(mediumImage))_t.jpg"
  }
  
  var link: String? {
    return item["link"].string
  }
  
  /**
  Constructor for FlickrItem
  
  - parameter item: Each flickr item json object
  */
  init(item: JSON) {
    self.item = item
  }
}