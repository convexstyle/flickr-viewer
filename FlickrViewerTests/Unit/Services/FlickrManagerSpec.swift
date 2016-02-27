//
//  FlickrManagerSpec.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 28/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

@testable import FlickrViewer

import Quick
import Nimble
import PromiseKit
import Mockingjay

class FlickrManagerSpec: QuickSpec {
  override func spec() {
    describe("FlickrManager") {
    
      let flickrManager = FlickrManager.sharedInstance
      let publicFeedURL = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
      let publicFeedString = fixtureStringFromFile("feed")!
      
      describe("#fetchFeed") {
        var promise: Promise<[FlickrItem]>!
        
        context("if successful") {
          beforeEach {
            self.stub(http(.GET, uri: publicFeedURL), builder: json(publicFeedString))
            
            promise = flickrManager.fetchFeed()
          }
          
          it("fulfilled should be called") {
            expect(promise.fulfilled).toEventually(beTrue(), timeout: 3)
          }
          
          it("should not be nil") {
            expect(promise.value).toEventuallyNot(beNil(), timeout: 3)
          }
          
          it("return 20 items") {
            expect(promise.value).toEventually(haveCount(20), timeout: 3)
          }
        }
        
        context("if unsuccessful") {
          beforeEach {
            self.stub(http(.GET, uri: publicFeedURL), builder: http(404))
          }
          
          it("return promise error") {
            promise = flickrManager.fetchFeed()
            expect(promise.fulfilled).toEventually(beFalse())
          }
        }
        
      }
      
    }
  }
}