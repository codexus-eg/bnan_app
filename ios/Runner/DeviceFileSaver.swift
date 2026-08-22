import Flutter
import Photos
import UIKit

final class DeviceFileSaver: NSObject, UIDocumentPickerDelegate {
  private let controller: FlutterViewController
  private var pendingResult: FlutterResult?
  private var exportURL: URL?

  init(controller: FlutterViewController) {
    self.controller = controller
  }

  func register() {
    let channel = FlutterMethodChannel(
      name: "bnan/device_file_saver",
      binaryMessenger: controller.binaryMessenger
    )
    channel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "saveFile" else {
        result(FlutterMethodNotImplemented)
        return
      }
      #if DEBUG
      print("BNAN_FILE_SAVER_IOS: saveFile called")
      #endif
      self?.save(call: call, result: result)
    }
    #if DEBUG
    print("BNAN_FILE_SAVER_IOS: channel registered")
    #endif
  }

  private func save(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let path = args["sourcePath"] as? String,
          let name = args["fileName"] as? String,
          !name.isEmpty,
          name == URL(fileURLWithPath: name).lastPathComponent else {
      fail(result, code: "INVALID_ARGUMENTS", message: "Invalid file arguments")
      return
    }
    let source = URL(fileURLWithPath: path)
    let size = try? source.resourceValues(forKeys: [.fileSizeKey]).fileSize
    guard FileManager.default.fileExists(atPath: source.path), (size ?? 0) > 0 else {
      fail(result, code: "INVALID_FILE", message: "File is empty or unavailable")
      return
    }
    if args["isImage"] as? Bool == true {
      saveImage(source, result: result)
    } else {
      export(source, name: name, result: result)
    }
  }

  private func saveImage(_ url: URL, result: @escaping FlutterResult) {
    let completion: (PHAuthorizationStatus) -> Void = { status in
      var granted = status == .authorized
      if #available(iOS 14, *), status == .limited { granted = true }
      guard granted else {
        self.fail(result, code: "PHOTO_PERMISSION_DENIED", message: "Photo access denied")
        return
      }
      PHPhotoLibrary.shared().performChanges({
        PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: url)
      }) { saved, error in
        DispatchQueue.main.async {
          if saved {
            result([
              "status": "saved",
              "location": "Photos",
              "canOpen": false
            ])
          } else {
            self.fail(result, code: "PHOTO_SAVE_FAILED", message: error?.localizedDescription)
          }
        }
      }
    }
    if #available(iOS 14, *) {
      PHPhotoLibrary.requestAuthorization(for: .addOnly, handler: completion)
    } else {
      PHPhotoLibrary.requestAuthorization(completion)
    }
  }

  private func export(_ source: URL, name: String, result: @escaping FlutterResult) {
    guard pendingResult == nil else {
      fail(result, code: "EXPORT_IN_PROGRESS", message: "Another export is active")
      return
    }
    do {
      let folder = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
      try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
      let target = folder.appendingPathComponent(name)
      try FileManager.default.copyItem(at: source, to: target)
      let picker = UIDocumentPickerViewController(url: target, in: .exportToService)
      pendingResult = result
      exportURL = target
      picker.delegate = self
      controller.present(picker, animated: true)
    } catch {
      fail(result, code: "EXPORT_FAILED", message: error.localizedDescription)
    }
  }

  func documentPicker(
    _ controller: UIDocumentPickerViewController,
    didPickDocumentsAt urls: [URL]
  ) {
    finishExport(status: "saved")
  }

  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    finishExport(status: "cancelled")
  }

  private func finishExport(status: String) {
    pendingResult?([
      "status": status,
      "location": status == "saved" ? "Files" : "",
      "canOpen": false
    ])
    pendingResult = nil
    if let folder = exportURL?.deletingLastPathComponent() {
      try? FileManager.default.removeItem(at: folder)
    }
    exportURL = nil
  }

  private func fail(_ result: @escaping FlutterResult, code: String, message: String?) {
    DispatchQueue.main.async {
      result(FlutterError(code: code, message: message, details: nil))
    }
  }
}
