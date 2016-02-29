//
//  PhotoItem.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 24/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import Foundation

/**
 Flickr data object store necessary fields
 */
struct FlickrItem {
  var originalImage: String?
  var mediumImage: String?
  var smallImage: String?
  var thumbnailImage: String?
  var link: String?
}