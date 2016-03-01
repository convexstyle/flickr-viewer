//
//  FlickrJsonParserSpec.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 28/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

@testable import FlickrViewer

import Quick
import Nimble
import SwiftyJSON


class FlickrJsonParserSpec: QuickSpec {
  override func spec() {
    describe("FlickrJsonParser") {
      
      describe("#parseJson") {
        it("return nil") {
          let data = stringToData("{ \"items\": \"test\" }")!
          let result = FlickrJsonParser.parseJson(data)
          
          expect(result).to(beNil())
        }
        
        context("when json is correct") {
          var result: [FlickrItem]?
          var expected = [FlickrItem]()
          
          beforeEach {
            result = FlickrJsonParser.parseJson(mockItemsData)
            
            // Assign each JSON object to FlickrItem model.
            expected.append(FlickrItem(item: mockItem))
          }
          
          it("count should be the same") {
            expect(result?.count == expected.count).to(beTrue())
          }
          
          it("first should not be nil") {
            expect(result?.first).toNot(beNil())
          }
          
          it("medium image should be same") {
            expect(result?.first!.mediumImage).to(equal(expected.first!.mediumImage))
          }
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
        
        it("return nil") {
          let imagePath = "test"
          let result = FlickrJsonParser.getSlugImagePath(imagePath)
          
          expect(result).to(beNil())
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