//
//  FlickrManager.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 23/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit
import SwiftyJSON

class FlickrManager {

  static let sharedInstance: FlickrManager = FlickrManager()
  
  let baseURLString = "https://api.flickr.com/services/"
  
  enum Path: String {
    case PublicFeed = "feeds/photos_public.gne"
  }
  
  // MARK: - Fetch
  func fetchFeed() -> Promise<[FlickrItem]> {
    let defered = Promise<[FlickrItem]>.pendingPromise()
    
//    let parameters = [
//      "format": "json",
//      "nojsoncallback": "1"
//    ]
//    
//    let url = "\(baseURLString)\(Path.PublicFeed.rawValue)"
//    Alamofire.request(.GET, url, parameters: parameters)
//      .validate()
//      .responseString { response in
//        switch response.result {
//        case .Success:
//          guard let jsonString = response.result.value, data = NSString(string: jsonString).dataUsingEncoding(NSUTF8StringEncoding) else {
//            return
//          }
//          
//          var json = JSON(data: data)
//          // TODO: - Flickr API returns invalid JSON string
//          if json == nil {
//            json = JSON(data: self.fixtureDataFromFile("flickr")!)
//          }
//          
//          guard let items = json["items"].array else {
//            return
//          }
//          
//          print("items >>> \(items)")
//          for item in items {
//            if let m = item["media"]["m"].string {
//              let pattern = "https://(.*)_m.jpg"
//              let result = Regexp(pattern).matches(m)
//              print(result)
//            }
//          }
//          
//          
//        case .Failure(let error):
//          print(error.description)
//        }
//      }
    
    let items = parseJson(self.fixtureDataFromFile("flickr")!)
    defered.fulfill(items)
    
    return defered.promise
  }
  
  func parseJson(data: NSData) -> [FlickrItem] {
    var flickrItems = [FlickrItem]()
    
    let json = JSON(data: data)
    
    guard let items = json["items"].array else {
      return flickrItems
    }
    
    for item in items {
      if let mediumImage = item["media"]["m"].string {
        let pattern = "(https:\\/\\/.*)_m\\.jpg"
        let replaceString = mediumImage.stringByReplacingOccurrencesOfString(pattern, withString: "$1", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        
        var item = FlickrItem()
        item.originalImage = "\(replaceString).jpg"
        item.mediumImage = mediumImage
        item.thumbnailImage = "\(replaceString)_t.jpg"
        item.smallImage = "\(replaceString)_s.jpg"
        
        flickrItems.append(item)
      }
    }
    
    print("flickrItems >>> \(flickrItems)")
    
    return flickrItems
  }
  
  func fixtureDataFromFile(name: String, ofType type: String = "json") -> NSData? {
    let bundle = NSBundle(identifier: "com.convexstyle.FlickrViewer")!
    let pathForFixture = bundle.pathForResource(name, ofType: type)!
    
    return NSData(contentsOfFile: pathForFixture)
  }

}
