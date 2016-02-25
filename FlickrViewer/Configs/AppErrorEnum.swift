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
  case JsonSyntaxError
  case SystemError(NSError)
  
  var description: String {
    switch self {
    case .LoadError:
      return "Load error"
      
    case .JsonSyntaxError:
      return "Json syntax error"
    
    case .SystemError(let error):
      return error.localizedDescription
      
    }
  }
}
