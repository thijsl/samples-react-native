import Foundation
import THEOplayerSDK

@objc final class THEOplayerHelper: NSObject {

  @objc static func initTheoPlayer() {
    THEOplayer.prepare(withFirstViewController: ViewControllerForTV())
  }

}
