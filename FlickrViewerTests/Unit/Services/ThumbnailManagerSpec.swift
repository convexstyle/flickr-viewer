//
//  ThumbnailManagerSpec.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 28/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

@testable import FlickrViewer

import Quick
import Nimble

class ThumbnailManagerSpec: QuickSpec {
  
  override func spec() {
    describe("ThumbnailManager") {

      class ThumbnailManagerDelegateMock: NSObject, ThumbnailManagerDelegate {
        var isCellDidSelectCalled = false
        
        func cellDidSelect(sender: ThumbnailManager, path: NSIndexPath) {
          isCellDidSelectCalled = true
        }
      }
      
      class UICollectionViewMock: UICollectionView {
        var isReloadDataCalled = false
        
        private override func reloadData() {
          isReloadDataCalled = true
        }
      }
      
      var thumbnailManager: ThumbnailManager!
      var collectionViewMock: UICollectionViewMock!
      var delegateMock: ThumbnailManagerDelegateMock!

      describe("#items") {
        
        beforeEach {
          thumbnailManager = ThumbnailManager()
          let flowLayout = UICollectionViewFlowLayout()
          collectionViewMock = UICollectionViewMock(frame: CGRectZero, collectionViewLayout: flowLayout)
          
          thumbnailManager.collectionView = collectionViewMock
          thumbnailManager.items = [ FlickrItem(), FlickrItem(), FlickrItem() ]
        }
        
        afterEach {
          thumbnailManager.collectionView = nil
          thumbnailManager.items = [FlickrItem]()
        }
        
        context("when items are set") {
          it("UICollectionView should be reloaded") {
            expect(collectionViewMock.isReloadDataCalled).to(beTrue())
          }
        }
        
        context("when UICollectionViewDataSource methods are called") {
          it("should return the count of number") {
            expect(
              thumbnailManager.collectionView(collectionViewMock, numberOfItemsInSection: 1) == thumbnailManager.items.count
             ).to(beTrue())
          }
        }
      }

      describe("#collectionView:didSelectItemAtIndexPath:") {
        beforeEach {
          delegateMock = ThumbnailManagerDelegateMock()
          
          thumbnailManager.delegate = delegateMock
          thumbnailManager.items = [ FlickrItem(), FlickrItem(), FlickrItem() ]
        }
        
        afterEach {
          thumbnailManager.delegate = nil
          thumbnailManager.items = [FlickrItem]()
        }
        
        it("should call cellDidSelect:path:") {
          thumbnailManager.collectionView(collectionViewMock, didSelectItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
          expect(delegateMock.isCellDidSelectCalled).to(beTrue())
        }
      }
      
    }
  }
  
}