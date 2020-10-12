
import Foundation
import UIKit
import THEOplayerSDK
import os.log

@objc(BaseTHEOplayerView)
class BaseTHEOplayerView: UIView, PlayerInterfaceViewDelegate {
  
  // MARK: - Public properties
  
  var theoplayer: THEOplayer
  var onSeek: RCTBubblingEventBlock?
  var onPlay: RCTBubblingEventBlock?
  var onPause: RCTBubblingEventBlock?
  var onEnded: RCTBubblingEventBlock?
  var onPresentationModeChange: RCTBubblingEventBlock?
  
  // MARK: - Private properties
  
  // View contains custom player interface
  private let playerInterface = PlayerInterfaceVC()
  private var listeners: [String: EventListener] = [:]
  
  // MARK: - Initialization
  
  init(player: THEOplayer) {
    self.theoplayer = player
    EventEmitter.sharedInstance.registerPlayer(player: player)
    
    super.init(frame: .zero)
    
    self.theoplayer.addAsSubview(of: self)
    self.theoplayer.presentationMode = .inline
    playerInterface.delegate = self
    attachEventListeners()
  }
  
  deinit {
    removeEventListeners()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public methods
  
  @objc(setSource:) func setSource(source: SourceDescription) {
    theoplayer.source = source
  }
  
  @objc(setAutoplay:) func setAutoplay(autoplay: Bool) {
    theoplayer.autoplay = autoplay
  }
  
  @objc(setFullscreenOrientationCoupling:) func setFullscreenOrientationCoupling(fullscreenOrientationCoupling: Bool) { }
  
  @objc(setOnSeek:) func setOnSeek(seek: @escaping RCTBubblingEventBlock) {
    onSeek = seek
  }
  
  @objc(setOnPlay:) func setOnPlay(play: @escaping RCTBubblingEventBlock) {
    onPlay = play
  }
  
  @objc(setOnPause:) func setOnPause(pause: @escaping RCTBubblingEventBlock) {
    onPause = pause
  }
  
  @objc(setOnEnded:) func setOnEnded(ended: @escaping RCTBubblingEventBlock) {
    onEnded = ended
  }
  
  // MARK: - UIView method
  
  override func layoutSubviews() {
    super.layoutSubviews()
    theoplayer.frame = frame
    theoplayer.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleWidth]
  }
  
  // MARK: - Player view customization
  
  ///Method take top view controller which is player view in fullscreen mode and add PlayerInterfaceVC as its child
  private func fullscreenPlayerInterfaceView() {
    guard let window = UIApplication.shared.keyWindow else {
      return
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
      guard let strongSelf = self, let topVC = window.rootViewController?.topVC() else {
        return
      }
      
      topVC.addChild(strongSelf.playerInterface)
      topVC.view.addSubview(strongSelf.playerInterface.view)
      
      strongSelf.playerInterface.view.leadingAnchor.constraint(equalTo: topVC.view.leadingAnchor).isActive = true
      strongSelf.playerInterface.view.trailingAnchor.constraint(equalTo: topVC.view.trailingAnchor).isActive = true
      strongSelf.playerInterface.view.topAnchor.constraint(equalTo: topVC.view.topAnchor).isActive = true
      strongSelf.playerInterface.view.bottomAnchor.constraint(equalTo: topVC.view.bottomAnchor).isActive = true
      strongSelf.playerInterface.didMove(toParent: topVC)
    })
  }
  
  // MARK: - THEOplayer listener related functions and closures
  
  private func attachEventListeners() {
    // Listen to event and store references in dictionary
    listeners["play"] = theoplayer.addEventListener(type: PlayerEventTypes.PLAY, listener: onPlay)
    listeners["playing"] = theoplayer.addEventListener(type: PlayerEventTypes.PLAYING, listener: onPlaying)
    listeners["pause"] = theoplayer.addEventListener(type: PlayerEventTypes.PAUSE, listener: onPause)
    listeners["ended"] = theoplayer.addEventListener(type: PlayerEventTypes.ENDED, listener: onEnded)
    listeners["error"] = theoplayer.addEventListener(type: PlayerEventTypes.ERROR, listener: onError)
    listeners["seeked"] = theoplayer.addEventListener(type: PlayerEventTypes.SEEKED, listener: onSeeked)
    listeners["sourceChange"] = theoplayer.addEventListener(type: PlayerEventTypes.SOURCE_CHANGE, listener: onSourceChange)
    listeners["readyStateChange"] = theoplayer.addEventListener(type: PlayerEventTypes.READY_STATE_CHANGE, listener: onReadyStateChange)
    listeners["waiting"] = theoplayer.addEventListener(type: PlayerEventTypes.WAITING, listener: onWaiting)
    listeners["durationChange"] = theoplayer.addEventListener(type: PlayerEventTypes.DURATION_CHANGE, listener: onDurationChange)
    listeners["timeUpdate"] = theoplayer.addEventListener(type: PlayerEventTypes.TIME_UPDATE, listener: onTimeUpdate)
    listeners["presentationModeChange"] = theoplayer.addEventListener(type: PlayerEventTypes.PRESENTATION_MODE_CHANGE, listener: onPresentationModeChange)
  }
  
  private func removeEventListeners() {
    // Remove event listenrs
    theoplayer.removeEventListener(type: PlayerEventTypes.PLAY, listener: listeners["play"]!)
    theoplayer.removeEventListener(type: PlayerEventTypes.PLAYING, listener: listeners["playing"]!)
    theoplayer.removeEventListener(type: PlayerEventTypes.PAUSE, listener: listeners["pause"]!)
    theoplayer.removeEventListener(type: PlayerEventTypes.ENDED, listener: listeners["ended"]!)
    theoplayer.removeEventListener(type: PlayerEventTypes.ERROR, listener: listeners["error"]!)
    theoplayer.removeEventListener(type: PlayerEventTypes.SEEKED, listener: listeners["seeked"]!)
    theoplayer.removeEventListener(type: PlayerEventTypes.SOURCE_CHANGE, listener: listeners["sourceChange"]!)
    theoplayer.removeEventListener(type: PlayerEventTypes.READY_STATE_CHANGE, listener: listeners["readyStateChange"]!)
    theoplayer.removeEventListener(type: PlayerEventTypes.WAITING, listener: listeners["waiting"]!)
    theoplayer.removeEventListener(type: PlayerEventTypes.DURATION_CHANGE, listener: listeners["durationChange"]!)
    theoplayer.removeEventListener(type: PlayerEventTypes.TIME_UPDATE, listener: listeners["timeUpdate"]!)
    theoplayer.removeEventListener(type: PlayerEventTypes.PRESENTATION_MODE_CHANGE, listener: listeners["presentationModeChange"]!)
    
    listeners.removeAll()
  }
  
  private func onPlay(event: PlayEvent) {
    print("PLAY event, currentTime: %f", event.currentTime)
    if playerInterface.state == .initialise {
      playerInterface.state = .buffering
    }
    self.onPlay?([:])
  }
  
  private func onPlaying(event: PlayingEvent) {
    print("PLAYING event, currentTime: %f", event.currentTime)
    playerInterface.state = .playing
  }
  
  private func onPause(event: PauseEvent) {
    print("PAUSE event, currentTime: %f", event.currentTime)
    // Pause might be triggered when Application goes into background which should be ignored if playback is not started yet
    if playerInterface.state != .initialise {
      playerInterface.state = .paused
    }
    self.onPause?([:])
  }
  
  private func onEnded(event: EndedEvent) {
    os_log("ENDED event, currentTime: %f", event.currentTime)
    // Stop player
    playerInterface.state = .paused
    theoplayer.stop()
    self.onEnded?([:])
  }
  
  private func onError(event: ErrorEvent) {
    os_log("ERROR event, error: %@", event.error)
  }
  
  private func onSourceChange(event: SourceChangeEvent) {
    os_log("SOURCE_CHANGE event, url: %@", event.source?.sources[0].src.absoluteString ?? "")
    // Initialise UI on source change
    playerInterface.state = .initialise
  }
  
  private func onReadyStateChange(event: ReadyStateChangeEvent) {
    os_log("READY_STATE_CHANGE event, state: %d", event.readyState.rawValue)
    // Restore the appropriate UI state if there is enough data
    if event.readyState == .HAVE_ENOUGH_DATA {
      playerInterface.state = theoplayer.paused ? .paused : .playing
    }
  }
  
  private func onWaiting(event: WaitingEvent) {
    os_log("WAITING event, currentTime: %f", event.currentTime)
    // Waiting event indicates there is not enough data to play, hence the buffering state
    playerInterface.state = .buffering
  }
  
  private func onDurationChange(event: DurationChangeEvent) {
    os_log("DURATION_CHANGE event, duration: %f", event.duration ?? 0.0)
    // Set UI duration
    if let duration = event.duration, duration.isNormal {
      playerInterface.duration = Float(duration)
    }
  }
  
  private func onTimeUpdate(event: TimeUpdateEvent) {
    os_log("TIME_UPDATE event, currentTime: %f", event.currentTime)
    // Update UI current time
    if !theoplayer.seeking {
      playerInterface.currentTime = Float(event.currentTime)
    }
  }
  
  private func onSeeked(event: CurrentTimeEvent) {
    os_log("SEEKED event, currentTime: %f", event.currentTime)
    self.onSeek?(["currentTime": event.currentTime])
  }
  
  private func onPresentationModeChange(event: PresentationModeChangeEvent) {
    os_log("PRESENTATION_MODE_CHANGE event, presentationMode: %d", event.presentationMode.rawValue)
    if event.presentationMode == .fullscreen {
      fullscreenPlayerInterfaceView()
    }
    self.onPresentationModeChange?([:])
  }
  
  // MARK: - PlayerInterfaceViewDelegate implementation
  
  func play() {
    if theoplayer.paused || theoplayer.ended {
      theoplayer.play()
    } else {
      theoplayer.pause()
    }
  }
  
  func pause() {
    theoplayer.pause()
  }
  
  func skip(isForward: Bool) {
    theoplayer.requestCurrentTime { (time, error) in
      if let timeInSeconds = time {
        var newTime = timeInSeconds + (isForward ? 10 : -10)
        // Make sure newTime is not less than 0
        newTime = newTime < 0 ? 0 : newTime
        if let duration = self.theoplayer.duration {
          // Make sure newTime is not bigger than duration
          newTime = newTime > duration ? duration : newTime
        }
        self.seek(timeInSeconds: Float(newTime))
      }
    }
  }
  
  func seek(timeInSeconds: Float) {
    // Set current time will trigger waiting event
    theoplayer.setCurrentTime(Double(timeInSeconds))
    playerInterface.currentTime = timeInSeconds
  }
  
  func closeFullscreen() {
    self.playerInterface.dismiss(animated: true) {
      self.theoplayer.presentationMode = .inline
    }
  }
}
