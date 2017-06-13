//
//  AppError.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 25/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import Foundation

/**
 Manage Flicker error type.
 */
enum FlickrError: Error {
  case loadError
  case jsonFormatError
  case noDataError
  case systemError(NSError)
  
  var description: String {
    switch self {
    case .loadError:
      return NSLocalizedString("flickrLoadErrorDescription", tableName: "App", value: "", comment: "Flickr json load error")
      
    case .jsonFormatError:
      return NSLocalizedString("flickrJsonErrorDescription", tableName: "App", value: "", comment: "Flickr json format error")
      
    case .noDataError:
      return NSLocalizedString("flickrNoDataErrorDescription", tableName: "App", value: "", comment: "Flickr no data error")
    
    case .systemError(let error):
      return error.localizedDescription
      
    }
  }
}

/**
Manage Connection error type.
*/
enum ConnectionError: Error {
  case noConnection
  
  var description: String {
    switch self {
    case .noConnection:
      return NSLocalizedString("internetConnectionErrorDescription", tableName: "App", value: "", comment: "No connection error")
    }
  }
}
