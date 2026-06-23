import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FilePickerHelper {
  const FilePickerHelper._();

  static Future<File?> pickFile({
    List<String> allowedExtensions = const ['pdf', 'jpg', 'jpeg', 'png'],
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );

    final path = result?.files.single.path;

    if (path == null) return null;

    return File(path);
  }
}