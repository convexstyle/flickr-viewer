//
//  UIViewController+AlertController.swift
//  FlickrViewer
//
//  Created by Hiroshi Tazawa on 1/03/2016.
//  Copyright © 2016 convexstyle. All rights reserved.
//

import UIKit

/**
 UIViewController extension to add snippet codes to open UIAlertViewController
 */
extension UIViewController {
  func presentAlertControllerWithAlertStyle(title: String?, message: String?, closeButtonTitle: String = "OK") {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.popoverPresentationController?.sourceView = self.view
    alertController.popoverPresentationController?.sourceRect = self.view.bounds
    alertController.popoverPresentationController?.permittedArrowDirections = []
    
    alertController.addAction(UIAlertAction(title: closeButtonTitle, style: .cancel, handler: nil))
    
    self.present(alertController, animated: true, completion: nil)
  }
}
