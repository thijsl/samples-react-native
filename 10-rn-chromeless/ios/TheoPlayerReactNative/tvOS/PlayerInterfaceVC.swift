//
//  PlayerInterfaceVC.swift
//  TheoPlayerReactNative-tvOS
//
//  Copyright © 2020 THEOPlayer. All rights reserved.
//

import UIKit

final class PlayerInterfaceVC: UIViewController {
  
  // MARK: - Public properties
  
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
  
  // MARK: - Private properties
  
  private var playerInterfaceView = PlayerInterfaceView()
  private var panGestureRecognizer: UIPanGestureRecognizer!
  private var progressViewWidth: Int = 0
  private var currentProgressWidth: Int = 0
  
  // MARK: - UIViewController Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .clear
    
    self.view.addSubview(self.playerInterfaceView)
    self.playerInterfaceView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    self.playerInterfaceView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    self.playerInterfaceView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    self.playerInterfaceView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let menuPressRecognizer = UITapGestureRecognizer()
    menuPressRecognizer.addTarget(self, action: #selector(menuButtonAction(recognizer:)))
    menuPressRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
    self.view.addGestureRecognizer(menuPressRecognizer)

    let playPausePressRecognizer = UITapGestureRecognizer()
    playPausePressRecognizer.addTarget(self, action: #selector(playPauseButtonAction(recognizer:)))
    playPausePressRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.playPause.rawValue)]
    self.view.addGestureRecognizer(playPausePressRecognizer)
    
    let selectButtonPressRecognizer = UITapGestureRecognizer()
    selectButtonPressRecognizer.addTarget(self, action: #selector(selectButtonAction(recognizer:)))
    selectButtonPressRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.select.rawValue)]
    self.view.addGestureRecognizer(selectButtonPressRecognizer)
    
    let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                      action: #selector(panGestureWasTriggered(panGestureRecognizer:)))
    self.view.addGestureRecognizer(panGestureRecognizer)
  }
  
  // MARK: - UITapGestureRecognizer actions handling
  
  @objc func menuButtonAction(recognizer: UITapGestureRecognizer) {
    delegate?.closeFullscreen()
  }

  @objc func playPauseButtonAction(recognizer: UITapGestureRecognizer) {
    delegate?.play()
  }
  
  @objc func selectButtonAction(recognizer: UITapGestureRecognizer) {
    delegate?.play()
  }
  
  // MARK: - UITapGestureRecognizer actions handling
  
  @objc private func panGestureWasTriggered(panGestureRecognizer: UIPanGestureRecognizer) {
    guard self.state == .paused && self.state != .buffering else {
      return
    }
    
    let translation = Int(panGestureRecognizer.translation(in: self.view).x)
    
    switch panGestureRecognizer.state {
    case .began:
      progressViewWidth = Int(playerInterfaceView.progressViewBorder.bounds.width)
      currentProgressWidth = Int(playerInterfaceView.progressViewWidthConstraint.constant)
      
    case .changed:
      let newProgressWidth = currentProgressWidth + translation
      var percentOfProgressBarFilling = Float(newProgressWidth) / Float(progressViewWidth)
      
      if percentOfProgressBarFilling > 1 {
        percentOfProgressBarFilling = 1
      }
      
      let newTime = duration * percentOfProgressBarFilling
      if newTime <= duration && newTime >= 0 {
        currentTime = newTime
      }
    case .ended, .cancelled:
      delegate?.seek(timeInSeconds: currentTime)
    default:
      break
    }
  }
  
}
