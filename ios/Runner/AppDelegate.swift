import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var deviceFileSaver: DeviceFileSaver?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let launched = super.application(
      application,
      didFinishLaunchingWithOptions: launchOptions
    )
    guard let controller = window?.rootViewController as? FlutterViewController else {
      return launched
    }
    deviceFileSaver = DeviceFileSaver(controller: controller)
    deviceFileSaver?.register()
    return launched
  }
}
