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
  let initIndexPath = IndexPath(item: 0, section: 0)
  
  /**
   The current NSIndexPath of large image's collectionView
   */
  var currentIndexPath = IndexPath(item: 0, section: 0)
  
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
  
  lazy var sharedApplication: UIApplication =  UIApplication.shared
  
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
    refreshButton.action = #selector(MainViewController.refreshButtonTouchUpInside(_:))
    let attributes = [
      NSFontAttributeName: UIFont.fontAwesome(ofSize: 20),
      NSForegroundColorAttributeName: UIColor.white
    ] as Dictionary!
    refreshButton.setTitleTextAttributes(attributes, for: .normal)
    refreshButton.title = String.fontAwesomeIcon(name: .refresh)
    navigationItem.rightBarButtonItem = refreshButton
    
    // UICollectionView setting for Large images
    imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: Constants.Keys.imageCollectionCellId)
    imageCollectionView.showsVerticalScrollIndicator = false
    imageCollectionView.showsHorizontalScrollIndicator = false
    imageCollectionView.alwaysBounceHorizontal = true
    imageCollectionView.isPagingEnabled = true
    imageCollectionView.delegate = self
    imageCollectionView.clipsToBounds = false
    imageCollectionView.dataSource = self
    
    // UICollectionView setting for Thumbnails
    thumbnailCollectionView.register(ThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: ThumbnailManager.Constants.Keys.thumbnailCellId)
    thumbnailCollectionView.showsVerticalScrollIndicator = false
    thumbnailCollectionView.showsHorizontalScrollIndicator = false
    thumbnailCollectionView.alwaysBounceHorizontal = true
    thumbnailCollectionView.isPagingEnabled = false
    thumbnailCollectionView.delegate = thumbnailManager
    thumbnailCollectionView.dataSource = thumbnailManager
    
    // External button
    externalLinkButton.addTarget(self, action: #selector(self.externalLinkButtonTouchUpInside(_:)), for: .touchUpInside)
    
    // Fetch Feed
    fetchFeed()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Add observer
    NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChangedHandler(_:)), name: ReachabilityChangedNotification, object: appDelegate?.reachability)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Remove observers
    NotificationCenter.default.removeObserver(self)
  }
  
  
  // MARK: - Refresh flickr feed
  /**
  Event handler method called after refresh button is tapped
  
  - parameter sender: UIBarButtonItem object
  */
  func refreshButtonTouchUpInside(_ sender: UIBarButtonItem) {
    fetchFeed()
  }
  
  
  // MARK: - Open SFsafariViewController to show a current Flickr page
  /**
  Event handler method called after external link button is tapped
  
  - parameter sender: UIButton object
  */
  func externalLinkButtonTouchUpInside(_ sender: UIButton) {
    if let link = items[currentIndexPath.item].link, let url = URL(string: link) {
      // Update statusBarStyle
      sharedApplication.statusBarStyle = UIStatusBarStyle.default
      
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
        
      }.catch { [weak self] error -> Void in
        guard let strongSelf = self else { return }
        if let error = error as? FlickrError {
          // Show FlickrError description
          TSMessage.showNotification(in: strongSelf, title: "Error", subtitle: error.description, type: .error)
        } else {
          // Show unknown error from library or system
          TSMessage.showNotification(in: strongSelf, title: "Error", subtitle: strongSelf.unknownError.description, type: .error)
        }
        
      }
  }
  
  
  // MARK: - Open SFSafariViewController
  /**
  Open SFSafariViewController
  
  - parameter url: NSURL object
  */
  func presentSFSafariViewControllerWithURL(_ url: URL) {
    let safariViewController = SFSafariViewController(url: url)
    safariViewController.modalTransitionStyle = .coverVertical
    safariViewController.modalPresentationStyle = .overFullScreen
    safariViewController.delegate = self
    self.present(safariViewController, animated: true, completion: nil)
  }
  
  
  // MARK: - Update externalLinkButton
  func updateExternalLinkButton() {
    externalLinkButton.isHidden = !externalLinkExist
  }
  
  
  // MARK: - Select current cells
  /**
  Select current thumbail and move to it
  
  - parameter path: NSIndexPath to select
  - parameter animated: Should animate or not
  - parameter scrollPosition: Which side of cell to be aligned
  */
  func selectThumbnailItemAtIndexPath(_ path: IndexPath, animated: Bool = true, scrollPosition: UICollectionViewScrollPosition = .left) {
    // Select cell
    let selectedCell = thumbnailCollectionView.cellForItem(at: path)
    selectedCell?.isSelected = true
    
    // Move to the selected cell
    thumbnailCollectionView.selectItem(at: path, animated: animated, scrollPosition: scrollPosition)
    
    currentIndexPath = path
  }
  
  /**
   Select current image and move to it
   
   - parameter path: NSIndexPath to select
   - parameter animated: Should animate or not
   - parameter scrollPosition: Which side of cell to be aligned
   */
  func selectImageItemAtIndexPath(_ path: IndexPath, animated: Bool = true, scrollPosition: UICollectionViewScrollPosition = .left) {
    imageCollectionView.selectItem(at: path, animated: animated, scrollPosition: scrollPosition)
  }
  
  
  // MARK: - Orientation
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    
    // Update flowlayout to support rotations
    imageCollectionView.collectionViewLayout.invalidateLayout()
    thumbnailCollectionView.collectionViewLayout.invalidateLayout()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    if dataSourceReady {
      mainView.layoutIfNeeded()
      imageCollectionView.selectItem(at: currentIndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.left)
      thumbnailCollectionView.selectItem(at: currentIndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.left)
    }
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
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
  func reachabilityChangedHandler(_ notification: Notification) {
    // Just in case, notification is sent before this view is loaded. Usually, it doesn't happen.
    if let reachability = notification.object as? Reachability, self.isViewLoaded == true {
      // When internet connection is back and items is still unset, then, fetch feed.
      if reachability.isReachable {
        if items.count == 0 {
          fetchFeed()
        }
      } else {
        // Avoid autoLayout background thread issue.
        DispatchQueue.main.async(execute: {
          self.presentAlertControllerWithAlertStyle(title: AppData.errorTitle, message: ConnectionError.noConnection.description)
        })
      }
    }
  }
}


// MARK: - ThumbnailManagerDelegate
extension MainViewController: ThumbnailManagerDelegate {
  func cellDidSelect(_ sender: ThumbnailManager, path: IndexPath) {
    selectImageItemAtIndexPath(path)
    selectThumbnailItemAtIndexPath(path)
  }
}


// MARK: - SFSafariViewControllerDelegate
extension MainViewController: SFSafariViewControllerDelegate {
  func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    // Update statusBarStyle
    UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
  }
}


// MARK: - UIScrollViewDelegate
extension MainViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let currentIndex = Int(imageCollectionView.contentOffset.x / imageCollectionView.frame.size.width)
    let currentIndexPath = IndexPath(item: currentIndex, section: 0)
    
    selectThumbnailItemAtIndexPath(currentIndexPath)
    updateExternalLinkButton()
  }
}


// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {}


// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Keys.imageCollectionCellId, for: indexPath)
    
    if let cell = cell as? ImageCollectionViewCell {
      configureImageCollectionViewCellWithItem(cell, item: items[indexPath.row])
    }
    
    return cell
  }
  
  fileprivate func configureImageCollectionViewCellWithItem(_ cell: ImageCollectionViewCell, item: FlickrItem) {
    cell.setNeedsDisplay()
    cell.imagePath = item.originalImage
  }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets.zero
  }
  
  //The minimum space (measured in points) to apply between successive lines in a section.
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  //The minimum space (measured in points) to apply between successive items in the lines of a section.
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}
