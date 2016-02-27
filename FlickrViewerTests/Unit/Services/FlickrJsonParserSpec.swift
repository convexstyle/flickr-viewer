//
//  FlickrJsonParserSpec.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 28/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

@testable import FlickrViewer

import XCTest
import Quick
import Nimble


class FlickrJsonParserSpec: QuickSpec {
  override func spec() {
    describe("FlickrJsonParser") {
      
      describe("#parseJson") {
        it("return nil") {
          let data = stringToData("{ \"items\": \"test\" }")!
          let result = FlickrJsonParser.parseJson(data)
          
          expect(result).to(beNil())
        }
        
        it("return FlickrItem array") {
          let data = fixtureDataFromFile("items")!
          let result = FlickrJsonParser.parseJson(data)
          
          var expected = [FlickrItem]()
          var flickrItem = FlickrItem()
          flickrItem.originalImage = "https://farm2.staticflickr.com/1657/24583733284_f545af71a3.jpg"
          flickrItem.mediumImage = "https://farm2.staticflickr.com/1657/24583733284_f545af71a3_m.jpg"
          flickrItem.smallImage = "https://farm2.staticflickr.com/1657/24583733284_f545af71a3_s.jpg"
          flickrItem.thumbnailImage = "https://farm2.staticflickr.com/1657/24583733284_f545af71a3_t.jpg"
          expected.append(flickrItem)
          
          expect(result?.count == expected.count).to(beTrue())
          expect(result?.first).toNot(beNil())
          expect(result?.first!.mediumImage).to(equal(expected.first!.mediumImage))
        }
      }
      
      describe("#removeBackSlashesFromEspcapedSingleQuotes") {
        it("return removed backSlashes string") {
          let data = "\'Hello World\'"
          let result = FlickrJsonParser.removeBackSlashesFromEspcapedSingleQuotes(data)
          let expected = "'Hello World'"
          
          expect(result).to(equal(expected))
        }
      }
      
      describe("#getSlugImagePath") {
        it("return slug image path") {
          let imagePath = "https://farm2.staticflickr.com/1565/24587574523_bcb6492ee3_m.jpg"
          let result = FlickrJsonParser.getSlugImagePath(imagePath)
          
          expect(result).to(equal("https://farm2.staticflickr.com/1565/24587574523_bcb6492ee3"))
        }
      }
      
      describe("#createQueryStringWithParameters") {
        it("return query string") {
          let parameters = [
            "format": "json",
            "nojsoncallback": "1"
          ]
          let result = FlickrJsonParser.createQueryStringWithParameters(parameters)
          
          expect(result).to(equal("format=json&nojsoncallback=1"))
        }
      }
      
      
    }
  }
}