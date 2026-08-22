import 'package:bnan_app/core/utils/device_file_saver.dart';
import 'package:bnan_app/core/utils/download_save_result.dart';
import 'package:bnan_app/core/utils/download_source.dart';
import 'package:flutter/foundation.dart';

class FileDownloader {
  const FileDownloader._();

  static Future<DownloadSaveResult> download({
    required String url,
    required String fileName,
  }) async {
    final value = url.trim();
    if (value.isEmpty) return const DownloadSaveResult.failed();

    try {
      final requestedName = fileName.trim().isEmpty
          ? 'downloaded_file'
          : fileName.trim();
      final name = requestedName.replaceAll(
        RegExp(r'[<>:"/\\|?*\x00-\x1F]'),
        '_',
      );

      final downloaded = await DownloadSource.obtain(value, name);
      if (downloaded == null) return const DownloadSaveResult.failed();
      try {
        final savedName = _nameForMimeType(name, downloaded.mimeType);
        return await DeviceFileSaver.save(
          source: downloaded.file,
          fileName: savedName,
          mimeType: downloaded.mimeType,
        );
      } finally {
        if (await downloaded.file.exists()) await downloaded.file.delete();
      }
    } catch (error) {
      debugPrint('DOWNLOAD ERROR: $error');
      return const DownloadSaveResult.failed();
    }
  }

  static String _nameForMimeType(String name, String mimeType) {
    final extension = switch (mimeType) {
      'image/png' => 'png',
      'image/jpeg' => 'jpg',
      'image/webp' => 'webp',
      'application/pdf' => 'pdf',
      _ => null,
    };
    if (extension == null) return name;
    final current = name.split('.').last.toLowerCase();
    if (current == extension || mimeType == 'image/jpeg' && current == 'jpeg') {
      return name;
    }
    final base = name.contains('.')
        ? name.substring(0, name.lastIndexOf('.'))
        : name;
    return '$base.$extension';
  }
}
