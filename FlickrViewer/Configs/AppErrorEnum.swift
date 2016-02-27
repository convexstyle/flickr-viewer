//
//  AppErrorEnum.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 25/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import Foundation

enum FlickrError: ErrorType {
  case LoadError
  case JsonFormatError
  case NoDataError
  case SystemError(NSError)
  
  var description: String {
    switch self {
    case .LoadError:
      return NSLocalizedString("flickrLoadErrorDescription", tableName: "App", value: "", comment: "Flickr json load error")
      
    case .JsonFormatError:
      return NSLocalizedString("flickrJsonErrorDescription", tableName: "App", value: "", comment: "Flickr json format error")
      
    case .NoDataError:
      return NSLocalizedString("flickrNoDataErrorDescription", tableName: "App", value: "", comment: "Flickr no data error")
    
    case .SystemError(let error):
      return error.localizedDescription
      
    }
  }
}
