//
//  MainViewController.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 23/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  
  lazy var mainView: MainView = MainView()
  lazy var flickrManager: FlickrManager = FlickrManager.sharedInstance
  
  // MARK: - View cycle
  override func loadView() {
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Fetch Feed
    fetchFeed()
  }
  
  
  // MARK: - Load feed
  func fetchFeed() {
    flickrManager.fetchFeed().then { items in
      print("items.count >>> \(items.count)")
    }
  }
  
}