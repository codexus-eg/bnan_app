import 'dart:io';

import 'package:bnan_app/core/helper/attachment_url_resolver.dart';
import 'package:bnan_app/core/utils/downloaded_file.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

abstract final class DownloadSource {
  static Future<DownloadedFile?> obtain(String source, String name) async {
    final target = File(
      '${(await getTemporaryDirectory()).path}/bnan_${DateTime.now().microsecondsSinceEpoch}_$name',
    );
    final uri = Uri.tryParse(source);
    final local = File(uri?.scheme == 'file' ? uri!.toFilePath() : source);
    String? contentType;
    if (await local.exists()) {
      await local.copy(target.path);
    } else if (source.startsWith('assets/')) {
      final data = await rootBundle.load(source);
      await target.writeAsBytes(data.buffer.asUint8List());
    } else {
      debugPrint('DOWNLOAD RAW URL: $source');
      final url = AttachmentUrlResolver.resolve(source);
      debugPrint('DOWNLOAD RESOLVED URL: $url');
      final resolved = Uri.tryParse(url);
      if (resolved == null ||
          !resolved.isScheme('http') && !resolved.isScheme('https')) {
        return null;
      }
      final dio = Dio(BaseOptions(baseUrl: resolved.origin));
      debugPrint('DOWNLOAD DIO BASE URL: ${dio.options.baseUrl}');
      debugPrint('DOWNLOAD FILE NAME: $name');
      late final Response<dynamic> response;
      try {
        response = await dio.download(
          url,
          target.path,
          options: Options(
            headers: await AttachmentUrlResolver.headersFor(url),
          ),
        );
        debugPrint('DOWNLOAD REQUEST URI: ${response.requestOptions.uri}');
        debugPrint('DOWNLOAD STATUS: ${response.statusCode}');
      } on DioException catch (e) {
        debugPrint('DOWNLOAD REQUEST URI: ${e.requestOptions.uri}');
        debugPrint('DOWNLOAD STATUS: ${e.response?.statusCode}');
        rethrow;
      }
      contentType = response.headers.value(Headers.contentTypeHeader);
    }
    if (!await target.exists() || await target.length() == 0) return null;
    return DownloadedFile(
      file: target,
      mimeType: _mimeType(contentType, name, source),
    );
  }

  static String _mimeType(String? header, String name, String source) {
    final value = header?.split(';').first.trim().toLowerCase();
    if (value?.isNotEmpty == true) return value!;
    final path = '${Uri.tryParse(name)?.path} ${Uri.tryParse(source)?.path}'
        .toLowerCase();
    if (path.contains('.png')) return 'image/png';
    if (path.contains('.jpg') || path.contains('.jpeg')) return 'image/jpeg';
    if (path.contains('.webp')) return 'image/webp';
    if (path.contains('.pdf')) return 'application/pdf';
    return 'application/octet-stream';
  }
}
