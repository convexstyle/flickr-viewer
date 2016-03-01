//
//  FlickrItemMock.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 1/03/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

@testable import FlickrViewer

import Quick
import Nimble
import SwiftyJSON

class FlickrItemMock: QuickSpec {
  override func spec() {
    
    describe("#FlickrItem") {
    
      context("when correct JSON is assigned") {
        
        var flickrItem: FlickrItem!
        
        beforeEach {
          flickrItem = FlickrItem(item: mockItem)
        }
        
        it("should get link") {
          expect(flickrItem.link).toNot(beNil())
        }
        
        it("should get original image") {
          expect(flickrItem.originalImage).toNot(beNil())
        }
        
        it("should get medium image") {
          expect(flickrItem.mediumImage).toNot(beNil())
        }
        
        it("should get small image") {
          expect(flickrItem.smallImage).toNot(beNil())
        }
        
        it("should get thumbnail image") {
          expect(flickrItem.thumbnailImage).toNot(beNil())
        }
      }
      
      context("when link is nil") {
        var flickrItem: FlickrItem!
        
        beforeEach {
          flickrItem = FlickrItem(item: mockNoLinkItem)
        }
        
        it("link should be nil") {
          expect(flickrItem.link).to(beNil())
        }
      }
      
      context("when link and medium image are empty") {
        var flickrItem: FlickrItem!
        
        beforeEach {
          flickrItem = FlickrItem(item: mockEmptyItem)
        }
        
        it("link should be nil") {
          expect(flickrItem.link).to(beNil())
        }
        
        it("medium image should be nil") {
          let expected = flickrItem.mediumImage
          expect(flickrItem.mediumImage).to(equal(expected))
        }
        
        it("should be not available") {
          expect(flickrItem.available).to(beFalse())
        }
      }
      
    }
    
  }
}
