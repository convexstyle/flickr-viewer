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
    let defered = Promise<[FlickrItem]>.pending()
    Alamofire.request(Router.publicFeed)
      .validate()
      .responseString { response in
        
        switch response.result {
        case .success:
          guard var jsonString = response.result.value else {
            defered.reject(FlickrError.loadError)
            return
          }
          
          // Remove unexpected escaped single quotes to avoid Flickr invalid json error
          jsonString = FlickrJsonParser.removeBackSlashesFromEspcapedSingleQuotes(jsonString)
          
          guard let data = jsonString.data(using: .utf8) else {
            defered.reject(FlickrError.loadError)
            return
          }
          
          guard var flickrItems = FlickrJsonParser.parseJson(data) else {
            defered.reject(FlickrError.jsonFormatError)
            return
          }
          
          if flickrItems.count == 0 {
            defered.reject(FlickrError.noDataError)
          } else {
            
            // Check the availablity of each item before resolving the promise
            flickrItems = flickrItems.filter({ $0.available })
            
            defered.fulfill(flickrItems)
          }
          
        case .failure(let error):
          defered.reject(FlickrError.systemError(error as NSError))
          
        }
      }
    
    return defered.promise
  }

}
