/// Copyright (c) 2018 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import Firebase

enum ValueKey: String {
  case appPrimaryColor
}

class RCValues {
  
  static let sharedInstance = RCValues()
  
  private init() {
    loadDefaultValues()
    fetchCloudValues()
  }
  
  func loadDefaultValues() {
    let appDefaults: [String: Any?] = [
      ValueKey.appPrimaryColor.rawValue : "#FBB03B"
    ]
    RemoteConfig.remoteConfig().setDefaults(appDefaults as? [String: NSObject])
  }
  
  func fetchCloudValues() {
    // 1
    // WARNING: Don't actually do this in production!
    let fetchDuration: TimeInterval = 0
    activateDebugMode()
    RemoteConfig.remoteConfig().fetch(withExpirationDuration: fetchDuration) { status, error in
      
      if let error = error {
        print("Uh-oh. Got an error fetching remote values \(error)")
        return
      }
      
      // 2
      RemoteConfig.remoteConfig().activateFetched()
      print("Retrieved values from the cloud!")
      
      let appPrimaryColorString = RemoteConfig.remoteConfig()
        .configValue(forKey: "appPrimaryColor")
        .stringValue ?? "undefined"
      print("Our app's primary color is \(appPrimaryColorString)")

    }
  }
  
  func activateDebugMode() {
    let debugSettings = RemoteConfigSettings(developerModeEnabled: true)
    RemoteConfig.remoteConfig().configSettings = debugSettings
  }
  
  func color(forKey key: ValueKey) -> UIColor {
    let colorAsHexString = RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? "#FFFFFF"
    let convertedColor = UIColor(colorAsHexString)
    return convertedColor
  }
  
}
