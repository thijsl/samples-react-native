//
//  PlayerInterfaceView.swift
//  TheoPlayerReactNative-tvOS
//
//  Copyright © 2020 THEOPlayer. All rights reserved.
//

import UIKit

final class PlayerInterfaceView: UIView {
  
  //MARK: - Public properties
  
  var delegate: PlayerInterfaceViewDelegate? = nil
  
  var progressViewWidthConstraint: NSLayoutConstraint!
  var progressViewBorder: UIView!
  
  var currentTime: Float = 0.0 {
    didSet {
      currentTimeString = Utilities.convertTimeString(time: currentTime,
                                                      isOverHourLong: isOverHourLong)
      if duration > 0 {
        DispatchQueue.main.async {
          let progress = self.currentTime / self.duration
          let progressWidth = Float(self.progressViewBorder.bounds.width) *  progress
          self.progressViewWidthConstraint.constant = CGFloat(progressWidth)
        }
      }
    }
  }
  
  var duration: Float = 0.0 {
    didSet {
      isOverHourLong = (duration / 3600) >= 1
      durationString = Utilities.convertTimeString(time: duration, isOverHourLong: isOverHourLong)
    }
  }
  
  var state: PlayerInterfaceViewState! {
    didSet {
      stopAutoHideTimer()
      switch state {
      case .initialise:
        containerView.isHidden = false
        currentTime = 0.0
        playPauseIcon.image = UIImage(named: "play")
      case .buffering:
        containerView.isHidden = false
        playPauseIcon.image = UIImage(named: "play")
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
      case .playing:
        startAutoHideTimer()
        playPauseIcon.image = UIImage(named: "pause")
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
      case .paused:
        containerView.isHidden = false
        playPauseIcon.image = UIImage(named: "play")
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
      default:
        break
      }
    }
  }
  
  // MARK: - Private properties
  
  private var containerView: UIView!
  private var playPauseIcon: UIImageView!
  private var progressView: UIView!
  private var isOverHourLong: Bool = false
  private var progressLabel: UILabel!
  private var activityIndicatorView: UIActivityIndicatorView!
  private var durationString: String = "00:00"
  
  // Auto hide timer variable and interval constant
  private var autoHideTimer: Timer? = nil
  private let autoHideTimeInSeconds: Double = 5.0
  
  // Boolean flag to show/hide the interface
  private var showInterface: Bool = true {
    didSet {
      // Start / stop auto hide timer and show / hide interface accordingly
      showInterface ? startAutoHideTimer() : stopAutoHideTimer()
      containerView.isHidden = !showInterface
    }
  }
  
  private var currentTimeString: String = "00:00" {
    didSet {
      DispatchQueue.main.async {
        self.progressLabel.text = "\(self.currentTimeString) / \(self.durationString)"
      }
    }
  }
  
  //MARK: - Initialization
  
  init() {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - View configuration
  
  private func setupView() {
    containerView = UIView()
    containerView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(containerView)
    containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    containerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    containerView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
    
    playPauseIcon = UIImageView()
    playPauseIcon.translatesAutoresizingMaskIntoConstraints = false
    playPauseIcon.image = UIImage(named: "play")
    playPauseIcon.widthAnchor.constraint(equalToConstant: 100).isActive = true
    playPauseIcon.heightAnchor.constraint(equalToConstant: 100).isActive = true
    containerView.addSubview(playPauseIcon)
    playPauseIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
    playPauseIcon.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
    
    progressLabel = UILabel()
    progressLabel.textColor = .white
    progressLabel.font = UIFont.systemFont(ofSize: 30)
    progressLabel.textAlignment = .center
    progressLabel.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(progressLabel)
    progressLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
    progressLabel.centerYAnchor.constraint(equalTo: playPauseIcon.centerYAnchor).isActive = true
    progressLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
    
    progressViewBorder = UIView()
    progressViewBorder.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(progressViewBorder)
    progressViewBorder.leadingAnchor.constraint(equalTo: playPauseIcon.trailingAnchor, constant: 40).isActive = true
    progressViewBorder.trailingAnchor.constraint(equalTo: progressLabel.leadingAnchor, constant: -20).isActive = true
    progressViewBorder.centerYAnchor.constraint(equalTo: playPauseIcon.centerYAnchor).isActive = true
    progressViewBorder.layer.borderWidth = 2
    progressViewBorder.layer.borderColor = UIColor.white.cgColor
    progressViewBorder.heightAnchor.constraint(equalToConstant: 10).isActive = true
    
    progressView = UIView()
    progressView.backgroundColor = .white
    progressView.translatesAutoresizingMaskIntoConstraints = false
    progressViewBorder.addSubview(progressView)
    progressView.leadingAnchor.constraint(equalTo: progressViewBorder.leadingAnchor).isActive = true
    progressView.topAnchor.constraint(equalTo: progressViewBorder.topAnchor).isActive = true
    progressView.bottomAnchor.constraint(equalTo: progressViewBorder.bottomAnchor).isActive = true
    progressViewWidthConstraint = progressView.widthAnchor.constraint(equalToConstant: 0)
    progressViewWidthConstraint.isActive = true
    
    activityIndicatorView = UIActivityIndicatorView(style: .white)
    activityIndicatorView.color = .white
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(activityIndicatorView)
    activityIndicatorView.widthAnchor.constraint(equalToConstant: 100).isActive = true
    activityIndicatorView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
  }
  
  // MARK: - Start/stop auto hide timer
  
  private func stopAutoHideTimer() {
    guard autoHideTimer != nil else { return }
    autoHideTimer?.invalidate()
    autoHideTimer = nil
  }
  
  private func startAutoHideTimer() {
    // Always terminate previous timer
    stopAutoHideTimer()
    // Create new timer
    autoHideTimer =  Timer.scheduledTimer(withTimeInterval: autoHideTimeInSeconds, repeats: false) { [weak self] _ in
      guard let self = self else { return }
      self.showInterface = false
    }
  }
  
}
