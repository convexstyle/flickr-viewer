//
//  FlickrManager.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 23/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON

class FlickrManager {

  static let sharedInstance: FlickrManager = FlickrManager()
  
  // MARK: - Fetch public feed
  /**
  Fetch public feed json
  
  @return PendingPromise object - Promise<[FlickrItem]>
  */
  func fetchFeed() -> Promise<[FlickrItem]> {
    let defered = Promise<[FlickrItem]>.pendingPromise()
    
    Alamofire.request(.GET, Router.PublicFeed.URL, parameters: Router.PublicFeed.parameters)
      .validate()
      .responseString { response in
        
        switch response.result {
        case .Success:
          guard var jsonString = response.result.value else {
            defered.reject(FlickrError.LoadError)
            return
          }
          
          // Remove unexpected escaped single quotes to avoid Flickr invalid json error
          jsonString = FlickrJsonParser.removeBackSlashesFromEspcapedSingleQuotes(jsonString)
          
          guard let data = NSString(string: jsonString).dataUsingEncoding(NSUTF8StringEncoding) else {
            defered.reject(FlickrError.LoadError)
            return
          }
          
          guard let flickrItems = FlickrJsonParser.parseJson(data) else {
            print("\(Router.PublicFeed.URL.absoluteString)?\(FlickrJsonParser.createQueryStringWithParameters(Router.PublicFeed.parameters)) returns wrong json format.")
            defered.reject(FlickrError.JsonFormatError)
            return
          }
          
          if flickrItems.count == 0 {
            print("\(Router.PublicFeed.URL.absoluteString)?\(FlickrJsonParser.createQueryStringWithParameters(Router.PublicFeed.parameters)) returns no items.")
            defered.reject(FlickrError.NoDataError)
          } else {
            defered.fulfill(flickrItems)
          }
          
        case .Failure(let error):
          defered.reject(FlickrError.SystemError(error))
          
        }
      }
    
    return defered.promise
  }

}
