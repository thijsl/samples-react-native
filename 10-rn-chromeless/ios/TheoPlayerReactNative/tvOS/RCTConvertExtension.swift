import Foundation
import THEOplayerSDK

@objc extension RCTConvert {
  
  @objc(SourceDescription:)
  class func sourceDescription(_ json: [String:AnyObject]) -> SourceDescription? {
    guard let sources = (json["sources"] as? [AnyObject]).flatMap(RCTConvert.typedSourceArray) else {
      return nil
    }
    
    return SourceDescription(
      sources: sources,
      textTracks: (json["textTracks"] as? [AnyObject]).flatMap(RCTConvert.textTrackArray),
      poster: RCTConvert.nsString(json["poster"]),
      metadata: nil
    )
  }
  
}
