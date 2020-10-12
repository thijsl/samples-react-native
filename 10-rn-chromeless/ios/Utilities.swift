//
//  Utilities.swift
//  TheoPlayerReactNative
//
//  Copyright © 2020 THEOPlayer. All rights reserved.
//

import Foundation

final class Utilities {
  
  ///Method converts time in seconds to format HH:MM:SS or MM:SS
  static func convertTimeString(time: Float, isOverHourLong: Bool) -> String {
    let seconds = Int(time)
    let (hour, mim, sec) = ((seconds / 3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60))
    
    if isOverHourLong {
      return String(format: "%02d:%02d:%02d", hour, mim, sec)
    } else {
      return String(format: "%02d:%02d", mim, sec)
    }
  }
  
}

extension UIViewController {
  
  ///Method return top view controller from view hierarchy
  @objc open func topVC() -> UIViewController {
    if let presentedViewController = self.presentedViewController {
      return presentedViewController.topVC()
    } else if let navigationController = self as? UINavigationController, let topNavVC = navigationController.topViewController {
      return topNavVC.topVC()
    } else if let tabBarController = self as? UITabBarController, let selectedVC = tabBarController.selectedViewController {
      return selectedVC.topVC()
    } else if let lastChild = self.children.last {
      return lastChild.topVC()
    }
    return self
  }
}
