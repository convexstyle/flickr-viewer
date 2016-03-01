//
//  AppData.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 24/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import Foundation

/**
 Manage app level data variables.
 */
struct AppData {
  static let appTitle = NSLocalizedString("appTitle", tableName: "App", value: "Flickr Photo Viewer", comment: "Photo viewer title")
  static let errorTitle = NSLocalizedString("errorTitle", tableName: "App", value: "", comment: "General error title")
}
