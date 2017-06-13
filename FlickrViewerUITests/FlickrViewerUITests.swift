//
//  FlickrViewerUITests.swift
//  FlickrViewerUITests
//
//  Created by Hiroshi Tazawa on 23/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import XCTest

class FlickrViewerUITests: XCTestCase {
  
  let app = XCUIApplication()
        
  override func setUp() {
    super.setUp()
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    XCUIApplication().launch()

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  
  func testCollectionViews() {
    let thumbnailCollectionView = app.collectionViews["thumbnailCollectionView"]
    let imageCollectionView = app.collectionViews["imageCollectionView"]
    
    let secondImageCell = imageCollectionView.children(matching: XCUIElementType.any).element(boundBy: 1)
    let secondThumbnailCell = thumbnailCollectionView.children(matching: XCUIElementType.any).element(boundBy: 1)
    if secondImageCell.exists && secondThumbnailCell.exists {
      secondThumbnailCell.tap()
      
      XCTAssertTrue(secondImageCell.isSelected)
      XCTAssertTrue(secondThumbnailCell.isSelected)
    }
  }
  
  func testExternalLinkButton() {
    let externalButton = app.buttons["externalLinkButton"]
    
    externalButton.forceTapElement()
    
    XCTAssertTrue(UIApplication.shared.statusBarStyle == UIStatusBarStyle.default)
  }
  
}

// Sends a tap event to a hittable/unhittable element.
extension XCUIElement {
  func forceTapElement() {
    if self.isHittable {
      self.tap()
    }
    else {
      let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0))
      coordinate.tap()
    }
  }
}
