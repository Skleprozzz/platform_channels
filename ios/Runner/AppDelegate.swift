import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // register plugin
    AppDeviceHelperPlugin.register(messenger: window.rootViewController as! FlutterBinaryMessenger)
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
