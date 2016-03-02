//
//  MainViewController.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 23/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit
import SafariServices
import FontAwesome_swift
import SVProgressHUD
import TSMessages
import ReachabilitySwift

class MainViewController: UIViewController {
  
  struct Constants {
    struct Keys {
      static let imageCollectionCellId = "MainViewController.imageCollectionCellId"
      static let thumbnailCollectionCellId = "MainViewController.thumbnailCollectionCellId"
    }
  }
  
  /**
   The initial NSIndexPath for both Large image's collectionView and thumbnail collectionView
   */
  let initIndexPath = NSIndexPath(forItem: 0, inSection: 0)
  
  /**
   The current NSIndexPath of large image's collectionView
   */
  var currentIndexPath = NSIndexPath(forItem: 0, inSection: 0)
  
  /**
   The items of Large image's collectionView
   */
  var items = [FlickrItem]() {
    didSet {
      imageCollectionView.reloadData()
    }
  }
  
  /**
   Variable to check items is set
  */
  var dataSourceReady: Bool {
    return items.count > 0
  }
  
  /**
   Variable to check the availability of external link
   */
  var externalLinkExist: Bool {
    return dataSourceReady && currentIndexPath.item < items.count && items[currentIndexPath.item].link != nil
  }
  
  lazy var unknownError: String = NSLocalizedString("unknownError", tableName: "App", comment: "Unknown Error")
  lazy var mainView: MainView = MainView()
  lazy var flickrManager: FlickrManager = FlickrManager.sharedInstance
  lazy var thumbnailManager: ThumbnailManager = {
    let manager = ThumbnailManager()
    manager.delegate = self
    manager.collectionView = self.thumbnailCollectionView
    
    return manager
  }()
  
  lazy var imageCollectionView: UICollectionView = {
    return self.mainView.imageCollectionView
  }()
  
  lazy var thumbnailCollectionView: UICollectionView = {
    return self.mainView.navCollectionView
  }()
  
  lazy var externalLinkButton: UIButton = {
    return self.mainView.externalLinkButton
  }()
  
  lazy var sharedApplication: UIApplication =  UIApplication.sharedApplication()
  
  lazy var appDelegate: AppDelegate? = {
    return self.sharedApplication.delegate as? AppDelegate
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
    
    // Add identifiers for UITests
    setIdentifiers()
    
    // NOTE: Using edgesForExtendedLayout for layout style produces some warnings when the orientation changes.
//    edgesForExtendedLayout = UIRectEdge.None
    
    automaticallyAdjustsScrollViewInsets = false
    
    // Navigation bar item
    let refreshButton = UIBarButtonItem()
    refreshButton.target = self
    refreshButton.action = "refreshButtonTouchUpInside:"
    let attributes = [
      NSFontAttributeName: UIFont.fontAwesomeOfSize(20),
      NSForegroundColorAttributeName: UIColor.whiteColor()
    ] as Dictionary!
    refreshButton.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
    refreshButton.title = String.fontAwesomeIconWithName(FontAwesome.Refresh)
    navigationItem.rightBarButtonItem = refreshButton
    
    // UICollectionView setting for Large images
    imageCollectionView.registerClass(ImageCollectionViewCell.self, forCellWithReuseIdentifier: Constants.Keys.imageCollectionCellId)
    imageCollectionView.showsVerticalScrollIndicator = false
    imageCollectionView.showsHorizontalScrollIndicator = false
    imageCollectionView.alwaysBounceHorizontal = true
    imageCollectionView.pagingEnabled = true
    imageCollectionView.delegate = self
    imageCollectionView.clipsToBounds = false
    imageCollectionView.dataSource = self
    
    // UICollectionView setting for Thumbnails
    thumbnailCollectionView.registerClass(ThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: ThumbnailManager.Constants.Keys.thumbnailCellId)
    thumbnailCollectionView.showsVerticalScrollIndicator = false
    thumbnailCollectionView.showsHorizontalScrollIndicator = false
    thumbnailCollectionView.alwaysBounceHorizontal = true
    thumbnailCollectionView.pagingEnabled = false
    thumbnailCollectionView.delegate = thumbnailManager
    thumbnailCollectionView.dataSource = thumbnailManager
    
    // External button
    externalLinkButton.addTarget(self, action: "externalLinkButtonTouchUpInside:", forControlEvents: UIControlEvents.TouchUpInside)
    
    // Fetch Feed
    fetchFeed()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    // Add observer
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChangedHandler:", name: ReachabilityChangedNotification, object: appDelegate?.reachability)
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Remove observers
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  
  // MARK: - Refresh flickr feed
  /**
  Event handler method called after refresh button is tapped
  
  - parameter sender: UIBarButtonItem object
  */
  func refreshButtonTouchUpInside(sender: UIBarButtonItem) {
    fetchFeed()
  }
  
  
  // MARK: - Open SFsafariViewController to show a current Flickr page
  /**
  Event handler method called after external link button is tapped
  
  - parameter sender: UIButton object
  */
  func externalLinkButtonTouchUpInside(sender: UIButton) {
    if let link = items[currentIndexPath.item].link, url = NSURL(string: link) {
      // Update statusBarStyle
      sharedApplication.statusBarStyle = UIStatusBarStyle.Default
      
      // Open Flickr page with SFSafariViewController
      presentSFSafariViewControllerWithURL(url)
    }
  }
  
  
  // MARK: - Load feed
  /**
  Load latest public feed json from Flickr
  */
  func fetchFeed() {
    SVProgressHUD.show()
    
    flickrManager.fetchFeed().then { items -> Void in
      self.items = items
      self.thumbnailManager.items = items
      
      self.selectImageItemAtIndexPath(self.initIndexPath, animated: false)
      self.selectThumbnailItemAtIndexPath(self.initIndexPath, animated: false)
      self.updateExternalLinkButton()
      
      }.always { _ -> Void in
        SVProgressHUD.dismiss()
        
      }.error { error -> Void in
        if let error = error as? FlickrError {
          // Show FlickrError description
          TSMessage.showNotificationWithTitle("Error", subtitle: error.description, type: .Error)
          
        } else {
          // Show unknown error from library or system
          TSMessage.showNotificationWithTitle("Error", subtitle: self.unknownError, type: .Error)
          
        }
        
      }
  }
  
  
  // MARK: - Open SFSafariViewController
  /**
  Open SFSafariViewController
  
  - parameter url: NSURL object
  */
  func presentSFSafariViewControllerWithURL(url: NSURL) {
    let safariViewController = SFSafariViewController(URL: url)
    safariViewController.modalTransitionStyle = .CoverVertical
    safariViewController.modalPresentationStyle = .OverFullScreen
    safariViewController.delegate = self
    self.presentViewController(safariViewController, animated: true, completion: nil)
  }
  
  
  // MARK: - Update externalLinkButton
  func updateExternalLinkButton() {
    externalLinkButton.hidden = !externalLinkExist
  }
  
  
  // MARK: - Select current cells
  /**
  Select current thumbail and move to it
  
  - parameter path: NSIndexPath to select
  - parameter animated: Should animate or not
  - parameter scrollPosition: Which side of cell to be aligned
  */
  func selectThumbnailItemAtIndexPath(path: NSIndexPath, animated: Bool = true, scrollPosition: UICollectionViewScrollPosition = .Left) {
    // Select cell
    let selectedCell = thumbnailCollectionView.cellForItemAtIndexPath(path)
    selectedCell?.selected = true
    
    // Move to the selected cell
    thumbnailCollectionView.selectItemAtIndexPath(path, animated: animated, scrollPosition: scrollPosition)
    
    currentIndexPath = path
  }
  
  /**
   Select current image and move to it
   
   - parameter path: NSIndexPath to select
   - parameter animated: Should animate or not
   - parameter scrollPosition: Which side of cell to be aligned
   */
  func selectImageItemAtIndexPath(path: NSIndexPath, animated: Bool = true, scrollPosition: UICollectionViewScrollPosition = .Left) {
    imageCollectionView.selectItemAtIndexPath(path, animated: animated, scrollPosition: scrollPosition)
  }
  
  
  // MARK: - Orientation
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    
    // Update flowlayout to support rotations
    imageCollectionView.collectionViewLayout.invalidateLayout()
    thumbnailCollectionView.collectionViewLayout.invalidateLayout()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    if dataSourceReady {
      mainView.layoutIfNeeded()
      imageCollectionView.selectItemAtIndexPath(currentIndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.Left)
      thumbnailCollectionView.selectItemAtIndexPath(currentIndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.Left)
    }
  }
  
  override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
  }
  
}


// MARK: - UITests
extension MainViewController {
  /**
   Set accessibilityIdentifier for UITests
   */
  func setIdentifiers() {
    externalLinkButton.accessibilityIdentifier = "externalLinkButton"
    imageCollectionView.accessibilityIdentifier = "imageCollectionView"
    thumbnailCollectionView.accessibilityIdentifier = "thumbnailCollectionView"
  }
}


// MARK: - Notification handlers
extension MainViewController {
  /**
   Whenener the connection status changes, reachabilityChangedHandler is called.
   
   - parameter notification: NSNotification object
  */
  func reachabilityChangedHandler(notification: NSNotification) {
    // Just in case, notification is sent before this view is loaded. Usually, it doesn't happen.
    if let reachability = notification.object as? Reachability where self.isViewLoaded() == true {
      // When internet connection is back and items is still unset, then, fetch feed.
      if reachability.isReachable() {
        if items.count == 0 {
          fetchFeed()
        }
      } else {
        // Avoid autoLayout background thread issue.
        dispatch_async(dispatch_get_main_queue(), {
          self.presentAlertControllerWithAlertStyle(title: AppData.errorTitle, message: ConnectionError.NoConnection.description)
        })
      }
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


// MARK: - SFSafariViewControllerDelegate
extension MainViewController: SFSafariViewControllerDelegate {
  func safariViewControllerDidFinish(controller: SFSafariViewController) {
    // Update statusBarStyle
    UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
  }
}


// MARK: - UIScrollViewDelegate
extension MainViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    let currentIndex = Int(imageCollectionView.contentOffset.x / imageCollectionView.frame.size.width)
    let currentIndexPath = NSIndexPath(forItem: currentIndex, inSection: 0)
    
    selectThumbnailItemAtIndexPath(currentIndexPath)
    updateExternalLinkButton()
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
    cell.setNeedsDisplay()
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