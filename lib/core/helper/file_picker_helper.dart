import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class FilePickerHelper {
  const FilePickerHelper._();

  static Future<File?> pickFile({
    List<String>? allowedExtensions = const ['pdf', 'jpg', 'jpeg', 'png'],
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: allowedExtensions == null ? FileType.any : FileType.custom,
      allowedExtensions: allowedExtensions,
    );
    _log('picker returned; cancelled=${result == null}');

    final path = result?.files.single.path;

    if (path == null) {
      _log('selected file path is null');
      return null;
    }

    final file = File(path);
    _log('selected file ready; exists=${file.existsSync()}');
    return file;
  }

  static Future<List<File>> pickFiles({List<String>? allowedExtensions}) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: allowedExtensions == null ? FileType.any : FileType.custom,
      allowedExtensions: allowedExtensions,
    );
    return result?.files
            .where((item) => item.path != null)
            .map((item) => File(item.path!))
            .toList() ??
        [];
  }

  static void _log(String message) {
    if (kDebugMode) debugPrint('[FilePickerHelper] $message');
  }
}
