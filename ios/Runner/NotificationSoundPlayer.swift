import AudioToolbox
import Flutter

final class NotificationSoundPlayer {
  private let channel: FlutterMethodChannel
  private var sequenceRemaining = 0

  init(controller: FlutterViewController) {
    channel = FlutterMethodChannel(
      name: "bnan/notification_sound",
      binaryMessenger: controller.binaryMessenger
    )
  }

  func register() {
    channel.setMethodCallHandler { call, result in
      if call.method == "playNudgeNotificationSequence" {
        if self.sequenceRemaining == 0 {
          self.sequenceRemaining = 3
          self.playNudgeTone()
        }
        result(nil)
        return
      }
      guard call.method == "playDefaultNotificationSound" else {
        result(FlutterMethodNotImplemented)
        return
      }
      AudioServicesPlaySystemSoundWithCompletion(1007) {
        result(nil)
      }
    }
  }

  private func playNudgeTone() {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    AudioServicesPlaySystemSoundWithCompletion(1007) { [weak self] in
      guard let self else { return }
      self.sequenceRemaining -= 1
      if self.sequenceRemaining > 0 {
        self.playNudgeTone()
      }
    }
  }
}
