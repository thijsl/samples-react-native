//
//  PlayerInterfaceVC.swift
//  TheoPlayerReactNative
//
//  Copyright © 2020 THEOPlayer. All rights reserved.
//

import UIKit

class PlayerInterfaceVC: UIViewController {
  
  var delegate: PlayerInterfaceViewDelegate? = nil
  
  var state: PlayerInterfaceViewState = .initialise {
    didSet {
      playerInterfaceView.state = state
    }
  }
  
  var duration: Float = 0.0 {
    didSet {
      playerInterfaceView.duration = duration
    }
  }
  
  var currentTime: Float = 0.0 {
    didSet {
      playerInterfaceView.currentTime = currentTime
    }
  }
  
  private var playerInterfaceView = PlayerInterfaceView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .clear
    self.view.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(playerInterfaceView)
    playerInterfaceView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    playerInterfaceView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    playerInterfaceView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    playerInterfaceView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    
    playerInterfaceView.skipBackwardButton.addTarget(self, action: #selector(onSkipBackward), for: .touchUpInside)
    playerInterfaceView.playButton.addTarget(self, action: #selector(onPlay), for: .touchUpInside)
    playerInterfaceView.pauseButton.addTarget(self, action: #selector(onPause), for: .touchUpInside)
    playerInterfaceView.skipForwardButton.addTarget(self, action: #selector(onSkipForward), for: .touchUpInside)
    playerInterfaceView.closeFullscreen.addTarget(self, action: #selector(onCloseFullscreen), for: .touchUpInside)
    
    playerInterfaceView.seek = { [weak self] value in
      self?.delegate?.seek(timeInSeconds: value)
    }
  }
  
  // MARK: - Button callbacks
  @objc private func onSkipBackward() {
    playerInterfaceView.showInterface = true
    delegate?.skip(isForward: false)
  }
  
  @objc private func onPlay() {
    playerInterfaceView.showInterface = true
    delegate?.play()
  }
  
  @objc private func onPause() {
    playerInterfaceView.showInterface = true
    delegate?.pause()
  }
  
  @objc private func onSkipForward() {
    playerInterfaceView.showInterface = true
    delegate?.skip(isForward: true)
  }
  
  @objc private func onCloseFullscreen() {
    playerInterfaceView.showInterface = true
    delegate?.closeFullscreen()
  }
  
}
