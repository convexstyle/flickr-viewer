//
//  FlickrItem.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 24/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit
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
  
  lazy var slugImagePath: String? = {
    guard let mediumImage = self.mediumImage, slugPath = FlickrJsonParser.getSlugImagePath(mediumImage) else {
      return nil
    }
    
    return slugPath
  }()
  
  var originalImage: String? {
    guard let mediumImage = mediumImage else {
      return nil
    }
    
    let result = FlickrJsonParser.getSlugImagePath(mediumImage)
    if result == nil {
      return nil
    }
    
    return "\(result!).jpg"
  }
  
  var mediumImage: String? {    
    return item["media"]["m"].string
  }
  
  var smallImage: String? {
    guard let mediumImage = mediumImage else {
      return nil
    }
    
    let result = FlickrJsonParser.getSlugImagePath(mediumImage)
    if result == nil {
      return nil
    }
    
    return "\(result!)_s.jpg"
  }
  
  var thumbnailImage: String? {
    guard let mediumImage = mediumImage else {
      return nil
    }
    
    let result = FlickrJsonParser.getSlugImagePath(mediumImage)
    if result == nil {
      return nil
    }
    
    return "\(result!)_t.jpg"
  }
  
  var link: String? {
    guard let link = item["link"].string else {
      return nil
    }
    
    if link.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" {
      return nil
    }
    
    return link
  }
  
  var available: Bool {
    return originalImage != nil && smallImage != nil
  }
  
  
  /**
  Constructor for FlickrItem
  
  - parameter item: Each flickr item json object
  */
  init(item: JSON) {
    self.item = item
  }
}