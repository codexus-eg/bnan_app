import 'dart:io';

class DownloadedFile {
  const DownloadedFile({required this.file, required this.mimeType});

  final File file;
  final String mimeType;
}
