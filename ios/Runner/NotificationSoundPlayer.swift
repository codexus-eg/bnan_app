import AudioToolbox
import Flutter

final class NotificationSoundPlayer {
  private let channel: FlutterMethodChannel

  init(controller: FlutterViewController) {
    channel = FlutterMethodChannel(
      name: "bnan/notification_sound",
      binaryMessenger: controller.binaryMessenger
    )
  }

  func register() {
    channel.setMethodCallHandler { call, result in
      guard call.method == "playDefaultNotificationSound" else {
        result(FlutterMethodNotImplemented)
        return
      }
      AudioServicesPlaySystemSoundWithCompletion(1007) {
        result(nil)
      }
    }
  }
}
