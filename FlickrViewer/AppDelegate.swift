//
//  AppDelegate.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 23/02/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import SVProgressHUD
import ReachabilitySwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var reachability: Reachability?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    window = UIWindow(frame: UIScreen.main.bounds)
    
    setAppearance()
    setReachability()
    
    let mainViewController     = MainViewController()
    let navigationController   = UINavigationController(rootViewController: mainViewController)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
    
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

// MARK: - Appearance
extension AppDelegate {
  func setAppearance() {
    setNavigationBarAppearance()
    setSVProgressHUD()
  }

  // MARK: - Set the appearance of NavigationBar
  func setNavigationBarAppearance() {
    let appearance = UINavigationBar.appearance()
    appearance.tintColor = UIColor.white
    appearance.barTintColor = UIColor("#3466b0")
    appearance.titleTextAttributes = [
      NSForegroundColorAttributeName: UIColor.white,
      NSFontAttributeName: UIFont.appBoldFontOfSize(AppFontSize.normal.rawValue)!
    ]
  }
  
   // MARK - Set the appearance of SVProgressHUD
  func setSVProgressHUD() {
    SVProgressHUD.setDefaultMaskType(.clear)
    SVProgressHUD.setBackgroundColor(UIColor("#3466b0"))
    SVProgressHUD.setForegroundColor(UIColor.white)
  }
}


// MARK: - Reachability
extension AppDelegate {
  /**
   Set reachability for the connection
   */
  func setReachability() {
    reachability = Reachability.init()
    
    do{
      try reachability?.startNotifier()
    } catch {
      print("could not start reachability notifier")
    }
  }
}

