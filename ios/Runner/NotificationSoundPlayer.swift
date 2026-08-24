import AVFoundation
import AudioToolbox
import Flutter

final class NotificationSoundPlayer {
  private let channel: FlutterMethodChannel
  private var nudgePlayer: AVAudioPlayer?
  private var chatRingPlayer: AVAudioPlayer?
  private var chatRingStop: DispatchWorkItem?

  init(controller: FlutterViewController) {
    channel = FlutterMethodChannel(
      name: "bnan/notification_sound",
      binaryMessenger: controller.binaryMessenger
    )
  }

  func register() {
    channel.setMethodCallHandler { call, result in
      if call.method == "playNudgeNotificationSequence" {
        self.playNudgeAlert()
        result(nil)
        return
      }
      if call.method == "playChatRing" {
        self.playChatRing()
        result(nil)
        return
      }
      if call.method == "stopChatRing" {
        self.stopChatRing()
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

  private func playNudgeAlert() {
    if nudgePlayer?.isPlaying == true { return }
    guard let url = Bundle.main.url(forResource: "nudge_alert", withExtension: "wav") else {
      return
    }
    do {
      let player = try AVAudioPlayer(contentsOf: url)
      nudgePlayer = player
      player.prepareToPlay()
      player.play()
      for delay in stride(from: 0.0, through: 6.0, by: 1.5) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self, weak player] in
          guard self?.nudgePlayer === player, player?.isPlaying == true else { return }
          AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
      }
    } catch {
      nudgePlayer = nil
    }
  }

  private func playChatRing() {
    stopChatRing()
    guard let url = Bundle.main.url(forResource: "chat_ring", withExtension: "wav") else {
      return
    }
    do {
      let player = try AVAudioPlayer(contentsOf: url)
      player.numberOfLoops = -1
      chatRingPlayer = player
      player.prepareToPlay()
      player.play()
      let stop = DispatchWorkItem { [weak self] in self?.stopChatRing() }
      chatRingStop = stop
      DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: stop)
    } catch {
      stopChatRing()
    }
  }

  private func stopChatRing() {
    chatRingStop?.cancel()
    chatRingStop = nil
    chatRingPlayer?.stop()
    chatRingPlayer = nil
  }
}
