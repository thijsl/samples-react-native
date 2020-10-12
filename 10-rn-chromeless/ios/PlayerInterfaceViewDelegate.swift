//
//  PlayerInterfaceViewDelegate.swift
//  TheoPlayerReactNative
//
//  Copyright © 2020 THEOPlayer. All rights reserved.
//

protocol PlayerInterfaceViewDelegate {
  func play()
  func pause()
  func skip(isForward: Bool)
  func seek(timeInSeconds: Float)
  func closeFullscreen()
}
