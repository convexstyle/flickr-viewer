//
//  MainViewController.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 23/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit
import FontAwesome_swift

class MainViewController: UIViewController {
  
  struct Constants {
    struct Keys {
      static let imageCollectionCellId = "MainViewController.imageCollectionCellId"
      static let thumbnailCollectionCellId = "MainViewController.thumbnailCollectionCellId"
      static let defaultCollectionCellId = "MainViewController.defaultCollectionCellId"
    }
  }
  
  let initIndexPath = NSIndexPath(forItem: 0, inSection: 0)
  
  var currentIndexPath = NSIndexPath(forItem: 0, inSection: 0)
  var items = [FlickrItem]() {
    didSet {
      mainView.imageCollectionView.reloadData()
    }
  }
  var dataSourceReady: Bool {
    return items.count > 0
  }
  
  lazy var mainView: MainView = MainView()
  lazy var flickrManager: FlickrManager = FlickrManager.sharedInstance
  lazy var thumbnailManager: ThumbnailManager = {
    let manager = ThumbnailManager()
    manager.delegate = self
    manager.collectionView = self.mainView.navCollectionView
    
    return manager
  }()
  lazy var imageCollectionView: UICollectionView = {
    return self.mainView.imageCollectionView
  }()
  lazy var thumbnailCollectionView: UICollectionView = {
    return self.mainView.navCollectionView
  }()
  
  
  // MARK: - Life cycle
  init() {
    super.init(nibName: nil, bundle: nil)
    
    title = AppData.appTitle
  }

  
  // MARK: - View cycle
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    // Layout Stype
//    edgesForExtendedLayout = UIRectEdge.None
    
    automaticallyAdjustsScrollViewInsets = false
    
    // Navigation bar item
    let refreshButton = UIBarButtonItem()
    refreshButton.target = self
    refreshButton.action = "refreshButtonTouchUpInside:"
    let attributes = [
      NSFontAttributeName: UIFont.fontAwesomeOfSize(20),
      NSForegroundColorAttributeName: UIColor.blackColor()
    ] as Dictionary!
    refreshButton.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
    refreshButton.title = String.fontAwesomeIconWithName(FontAwesome.Refresh)
    navigationItem.rightBarButtonItem = refreshButton
    
    // Large images
    mainView.imageCollectionView.registerClass(ImageCollectionViewCell.self, forCellWithReuseIdentifier: Constants.Keys.imageCollectionCellId)
    mainView.imageCollectionView.showsVerticalScrollIndicator = false
    mainView.imageCollectionView.showsHorizontalScrollIndicator = false
    mainView.imageCollectionView.alwaysBounceHorizontal = true
    mainView.imageCollectionView.pagingEnabled = true
    mainView.imageCollectionView.delegate = self
    mainView.imageCollectionView.clipsToBounds = false
    mainView.imageCollectionView.dataSource = self
    
    // Thumbnails
    mainView.navCollectionView.registerClass(ThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: ThumbnailManager.Constants.Keys.thumbnailCellId)
    mainView.navCollectionView.showsVerticalScrollIndicator = false
    mainView.navCollectionView.showsHorizontalScrollIndicator = false
    mainView.navCollectionView.alwaysBounceHorizontal = true
    mainView.navCollectionView.pagingEnabled = false
    mainView.navCollectionView.delegate = thumbnailManager
    mainView.navCollectionView.dataSource = thumbnailManager
    
    // Fetch Feed
    fetchFeed()
  }
  
  
  // MARK: - Button
  func refreshButtonTouchUpInside(sender: UIBarButtonItem) {
    fetchFeed()
  }
  
  
  // MARK: - Load feed
  func fetchFeed() {
    // TODO: - Error and HUD
    flickrManager.fetchFeed().then { items -> Void in
      self.items = items
      self.thumbnailManager.items = items
      
      self.selectImageItemAtIndexPath(self.initIndexPath, animated: false)
      self.selectThumbnailItemAtIndexPath(self.initIndexPath, animated: false)
    }
  }
  
  
  // MARK: - Cell
  func selectThumbnailItemAtIndexPath(path: NSIndexPath, animated: Bool = true, scrollPosition: UICollectionViewScrollPosition = .Left) {
    // Select cell
    let selectedCell = mainView.navCollectionView.cellForItemAtIndexPath(path)
    selectedCell?.selected = true
    
    // Move to the selected cell
    mainView.navCollectionView.selectItemAtIndexPath(path, animated: animated, scrollPosition: scrollPosition)
    
    currentIndexPath = path
  }
  
  func selectImageItemAtIndexPath(path: NSIndexPath, animated: Bool = true, scrollPosition: UICollectionViewScrollPosition = .Left) {
    mainView.imageCollectionView.selectItemAtIndexPath(path, animated: animated, scrollPosition: scrollPosition)
  }
  
  
  // MARK: - Orientation
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    
    if dataSourceReady {
//      mainView.imageCollectionView.performBatchUpdates(nil, completion: nil)
//      mainView.imageCollectionView.setContentOffset(CGPoint(x: size.width * CGFloat(currentIndexPath.item), y: 0), animated: false)
//      for cell in mainView.imageCollectionView.visibleCells() {
//        if let cell = cell as? ImageCollectionViewCell {
//          cell.imageView.contentMode = UIViewContentMode.ScaleAspectFit
//        }
//      }
      
//      let thumbnailsTargetX = size.width/4 * CGFloat(min(currentIndexPath.item, 16))
//      mainView.navCollectionView.setContentOffset(CGPoint(x: thumbnailsTargetX, y: 0), animated: false)
    }
  }
  
  override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    
    if traitCollection != previousTraitCollection {      
      mainView.imageCollectionView.collectionViewLayout.invalidateLayout()
      mainView.navCollectionView.collectionViewLayout.invalidateLayout()
    }
  }
  
}


// MARK: - ThumbnailManagerDelegate
extension MainViewController: ThumbnailManagerDelegate {
  func cellDidSelect(sender: ThumbnailManager, path: NSIndexPath) {
    selectImageItemAtIndexPath(path)
    selectThumbnailItemAtIndexPath(path)
  }
}


// MARK: - UIScrollViewDelegate
extension MainViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    let currentIndex = Int(mainView.imageCollectionView.contentOffset.x / mainView.imageCollectionView.frame.size.width)
    let currentIndexPath = NSIndexPath(forItem: currentIndex, inSection: 0)
    
    selectThumbnailItemAtIndexPath(currentIndexPath)
  }
}


// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {}


// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.Keys.imageCollectionCellId, forIndexPath: indexPath)
    
    if let cell = cell as? ImageCollectionViewCell {
      configureImageCollectionViewCellWithItem(cell, item: items[indexPath.row])
    }
    
    return cell
  }
  
  private func configureImageCollectionViewCellWithItem(cell: ImageCollectionViewCell, item: FlickrItem) {
    cell.imagePath = item.originalImage
  }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    return UIEdgeInsetsZero
  }
  
  //The minimum space (measured in points) to apply between successive lines in a section.
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 0
  }
  
  //The minimum space (measured in points) to apply between successive items in the lines of a section.
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 0
  }
}