import 'dart:io';

import 'package:bnan_app/core/utils/download_save_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

abstract final class DeviceFileSaver {
  static const _channel = MethodChannel('bnan/device_file_saver');

  static Future<DownloadSaveResult> save({
    required File source,
    required String fileName,
    required String mimeType,
  }) async {
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        final result = await _channel
            .invokeMapMethod<String, dynamic>('saveFile', {
              'sourcePath': source.path,
              'fileName': fileName,
              'mimeType': mimeType,
              'isImage': mimeType.startsWith('image/'),
            });
        return _resultFrom(result, mimeType);
      } on MissingPluginException catch (error) {
        debugPrint('BNAN_FILE_SAVER: native channel unavailable: $error');
        return const DownloadSaveResult.failed();
      } on PlatformException catch (error) {
        debugPrint('BNAN_FILE_SAVER: native save failed: ${error.code}');
        return const DownloadSaveResult.failed();
      }
    }
    final directory = await getDownloadsDirectory();
    if (directory == null) return const DownloadSaveResult.failed();
    final saved = await source.copy('${directory.path}/$fileName');
    final valid =
        await saved.exists() && await saved.length() == await source.length();
    return valid
        ? DownloadSaveResult(
            status: DownloadSaveStatus.saved,
            location: directory.path,
            reference: saved.path,
            mimeType: mimeType,
          )
        : const DownloadSaveResult.failed();
  }

  static Future<bool> open(DownloadSaveResult result) async {
    if (!result.canOpen || result.reference == null) return false;
    try {
      return await _channel.invokeMethod<bool>('openFile', {
            'reference': result.reference,
            'mimeType': result.mimeType,
          }) ??
          false;
    } on MissingPluginException catch (error) {
      debugPrint('BNAN_FILE_SAVER: open channel unavailable: $error');
      return false;
    } on PlatformException catch (error) {
      debugPrint('BNAN_FILE_SAVER: open failed: ${error.code}');
      return false;
    }
  }

  static DownloadSaveResult _resultFrom(
    Map<String, dynamic>? value,
    String mimeType,
  ) => DownloadSaveResult(
    status: switch (value?['status']) {
      'saved' => DownloadSaveStatus.saved,
      'cancelled' => DownloadSaveStatus.cancelled,
      _ => DownloadSaveStatus.failed,
    },
    location: value?['location'] as String?,
    reference: value?['reference'] as String?,
    mimeType: mimeType,
    canOpen: value?['canOpen'] == true,
  );
}
