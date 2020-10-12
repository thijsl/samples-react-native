import Foundation
import THEOplayerSDK

@objc extension THEOplayerViewManager {
  
  @objc
  func scheduleAd(_ jsAdDescription: [String : Any]) {
    do {
      let data = try JSONSerialization.data(withJSONObject: jsAdDescription)
      let adDescription = try JSONDecoder().decode(THEOAdDescription.self, from: data)
      playerView.theoplayer.ads.schedule(adDescription: adDescription)
    } catch {
      print(error)
    }
  }
  
  @objc(getCurrentAds:reject:)
  func getCurrentAds(_ resolve: @escaping RCTPromiseResolveBlock, _ reject: @escaping RCTPromiseRejectBlock) {
    playerView.theoplayer.ads.requestCurrentAds{ result, error in
      if error != nil || result == nil {
        reject(nil, nil, error!)
      } else {
        resolve(result!.count)
      }
    }
  }
  
}
