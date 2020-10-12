import Foundation
import THEOplayerSDK

@objc extension RCTConvert {
  
  @objc(AdDescription:)
  class func adDescription(_ json: [String:AnyObject]) -> THEOAdDescription? {
    guard let src = RCTConvert.nsString(json["sources"]) else {
      return nil
    }
    
    return THEOAdDescription(
      src: src,
      timeOffset: RCTConvert.nsString(json["timeOffset"]),
      skipOffset: RCTConvert.nsString(json["skipOffset"])
    )
  }
  
  @available(iOS 11.0, *)
  @objc(AdDescriptionArray:)
  class func adDescriptionArray(_ json: [AnyObject]) -> [THEOAdDescription]? {
    let sources = RCTConvertArrayValue(#selector(adDescription), json)
      .compactMap { $0 as? THEOAdDescription }
    return sources.count > 0 ? sources : nil
  }
  
  @objc(SourceDescription:)
  class func sourceDescription(_ json: [String:AnyObject]) -> SourceDescription? {
    guard let sources = (json["sources"] as? [AnyObject]).flatMap(RCTConvert.typedSourceArray) else {
      return nil
    }
    
    return SourceDescription(
      sources: sources,
      ads: (json["ads"] as? [AnyObject]).flatMap(RCTConvert.adDescriptionArray),
      textTracks: (json["textTracks"] as? [AnyObject]).flatMap(RCTConvert.textTrackArray),
      poster: RCTConvert.nsString(json["poster"]),
      analytics: nil,
      metadata: nil
    )
  }
}
