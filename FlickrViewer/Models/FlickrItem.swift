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
  
  // Slug image path
  lazy var slugImagePath: String? = {
    guard let mediumImage = self.mediumImage, let slugPath = FlickrJsonParser.getSlugImagePath(mediumImage) else {
      return nil
    }
    
    return slugPath
  }()
  
  // Original image url
  var originalImage: String? {
    if slugImagePath == nil {
      return nil
    }
    
    return "\(slugImagePath!).jpg"
  }
  
  // Medium image url
  var mediumImage: String? {    
    return item["media"]["m"].string
  }
  
  // Small image url
  var smallImage: String? {
    if slugImagePath == nil {
      return nil
    }
    
    return "\(slugImagePath!)_s.jpg"
  }
  
  // Thumbnail image url
  var thumbnailImage: String? {
    if slugImagePath == nil {
      return nil
    }
    
    return "\(slugImagePath!)_t.jpg"
  }
  
  // Flickr page url
  var link: String? {
    guard let link = item["link"].string else {
      return nil
    }
    
    if link.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
      return nil
    }
    
    return link
  }
  
  // If original image amd small image are not provided, then, this item has to be ignored to display
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
