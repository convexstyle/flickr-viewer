//
//  MockObject.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 1/03/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import Foundation
import SwiftyJSON

// Empty mock object
let mockJSON = JSON(data: Data())

// Mock object for items
let mockItemsData = fixtureDataFromFile("items")!
let mockItemsJSON = JSON(data: mockItemsData)
let mockItems = mockItemsJSON["items"].array!
let mockItem = mockItems.first!

// Mock object for no link item
let mockItemsNoLinkData = fixtureDataFromFile("items-no-link")!
let mockNoLinkJSON = JSON(data: mockItemsNoLinkData)
let mockNoLinkItems = mockNoLinkJSON["items"].array!
let mockNoLinkItem = mockNoLinkItems.first!

// Mock object for empty link and medium image item
let mockItemsEmptyData = fixtureDataFromFile("items-empty")!
let mockEmptyJSON = JSON(data: mockItemsEmptyData)
let mockEmptyItems = mockEmptyJSON["items"].array!
let mockEmptyItem = mockEmptyItems.first!
