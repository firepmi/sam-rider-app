import UIKit
import Flutter
import GoogleMaps
import Firebase
import FirebaseAuth

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyB94toBjU5Ne7fz3xfjjS1PsgwaCabFKXg")
    GeneratedPluginRegistrant.register(with: self)
//    let token =
//    Auth.auth().setAPNSToken(deviceToken, type: .prod)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

}
