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
  func fetchFeed() -> Promise<[FlickrItem]> {
    let defered = Promise<[FlickrItem]>.pendingPromise()

    // NOTE: Test locally
//    let items = parseJson(self.fixtureDataFromFile("flickr")!)
//    defered.fulfill(items)
    
    Alamofire.request(.GET, Router.PublicFeed.URL, parameters: Router.PublicFeed.parameters)
      .validate()
      .responseString { response in
        switch response.result {
        case .Success:
          guard let jsonString = response.result.value, data = NSString(string: jsonString).dataUsingEncoding(NSUTF8StringEncoding) else {
            // TODO: - If json is nil, it is usually because of the incorrect format json from Flickr. This is the fallback to load local fixture json file.
            defered.reject(FlickrError.LoadError)
            return
          }
          
          guard let flickrItems = FlickrJsonParser.parseJson(data) else {
            print("\(Router.PublicFeed.URL.absoluteString)?\(FlickrJsonParser.createQueryStringWithParameters(Router.PublicFeed.parameters)) returns wrong json format.")
            defered.reject(FlickrError.JsonError)
            return
          }
          
          if flickrItems.count == 0 {
            print("\(Router.PublicFeed.URL.absoluteString)?\(FlickrJsonParser.createQueryStringWithParameters(Router.PublicFeed.parameters)) returns no items.")
            defered.reject(FlickrError.NoDataError)
            return
          }
          
          defered.fulfill(flickrItems)
          
        case .Failure(let error):
          defered.reject(error)
          
        }
      }
    
    return defered.promise
  }

}
