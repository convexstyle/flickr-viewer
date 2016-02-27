//
//  MainControllerSpec.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 28/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

@testable import FlickrViewer

import Quick
import Nimble

class MainViewControllerSpec: QuickSpec {
  override func spec() {
    describe("MainViewController") {
    
      class MainViewControllerMock: MainViewController {
        var isFetchFeedCalled = false
        var isPresentSFSafariViewControllerWithURLCalled = false
        
        private override func fetchFeed() {
          isFetchFeedCalled = true
        }
        
        private override func presentSFSafariViewControllerWithURL(url: NSURL) {
          isPresentSFSafariViewControllerWithURLCalled = true
        }
      }
      
      let mainViewControllerMock: MainViewControllerMock = MainViewControllerMock()
      
      describe("#items") {
        var items = [FlickrItem]()
        
        beforeEach {
          items = [FlickrItem(), FlickrItem() ,FlickrItem()]
        }
        
        it("dataSourceReady should be true") {
          mainViewControllerMock.items = items
          
          expect(mainViewControllerMock.dataSourceReady).to(beTrue())
        }
      }
      
      describe("#refreshButtonTouchUpInside") {
        it("should fetch feed") {
          let refreshButtonItem = UIBarButtonItem()
          mainViewControllerMock.refreshButtonTouchUpInside(refreshButtonItem)
          
          expect(mainViewControllerMock.isFetchFeedCalled).to(beTrue())
        }
      }
      
      describe("#externalLinkExist") {
        
        afterEach {
           mainViewControllerMock.items = [FlickrItem]()
        }
        
        context("when link is set in the first FlickrItem") {
          beforeEach {
            var item = FlickrItem()
            item.link = "http://www.test.com"
            
            mainViewControllerMock.items = [item]
          }
          
          it("should be true") {
            expect(mainViewControllerMock.externalLinkExist).to(beTrue())
          }
          
          it("externalLinkButton should be visible") {
            mainViewControllerMock.updateExternalLinkButton()
            expect(mainViewControllerMock.externalLinkButton.hidden).to(beFalse())
          }
        }
        
        context("when the link is nil in the first FlickrItem") {
          beforeEach {
            var item = FlickrItem()
            item.link = nil
            
            mainViewControllerMock.items = [item]
          }
          
          it("should be false") {
            mainViewControllerMock.updateExternalLinkButton()
            expect(mainViewControllerMock.externalLinkExist).to(beFalse())
          }
          
          it("externalLinkButton should be invisible") {
            expect(mainViewControllerMock.externalLinkButton.hidden).to(beTrue())
          }
        }
      }
      
      describe("#externalLinkButtonTouchUpInside") {
        
        afterEach {
          mainViewControllerMock.isPresentSFSafariViewControllerWithURLCalled = false
        }
        
        context("when item.link exists") {
          beforeEach {
            var item = FlickrItem()
            item.link = "http://www.test.com"
            
            mainViewControllerMock.items = [item]
          }
          
          it("should present SFSafariViewController") {
            let button = UIButton()
            mainViewControllerMock.externalLinkButtonTouchUpInside(button)
            
            expect(mainViewControllerMock.isPresentSFSafariViewControllerWithURLCalled).to(beTrue())
          }
        }
        
        context("when item.link is nil") {
          beforeEach {
            var item = FlickrItem()
            item.link = nil
            
            mainViewControllerMock.items = [item]
          }
          
          it("should not present SFSafariViewController") {
            expect(mainViewControllerMock.isPresentSFSafariViewControllerWithURLCalled).to(beFalse())
          }
        }
      }
      
    }
  }
}
