import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class FileDownloader {
  const FileDownloader._();

  static Future<bool> download({
    required String url,
    required String fileName,
  }) async {
    final value = url.trim();
    if (value.isEmpty) return false;

    try {
      final directory = await _getDownloadDirectory();
      if (directory == null) return false;

      final name = fileName.trim().isEmpty
          ? 'downloaded_file'
          : fileName.trim();

      final path = '${directory.path}/$name';

      await Dio().download(
        value,
        path,
      );

      return true;
    } catch (error) {
      print('DOWNLOAD ERROR: $error');
      return false;
    }
  }

  static Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      final downloads = await getDownloadsDirectory();

      if (downloads != null) {
        return downloads;
      }

      return getExternalStorageDirectory();
    }

    if (Platform.isIOS) {
      return getApplicationDocumentsDirectory();
    }

    return null;
  }
}