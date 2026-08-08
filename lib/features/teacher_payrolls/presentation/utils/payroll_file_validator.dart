import 'dart:io';

abstract final class PayrollFileValidator {
  static const maxBytes = 5 * 1024 * 1024;
  static const extensions = {'png', 'jpg', 'jpeg', 'webp'};
  static Future<String?> validate(String path) async {
    final file = File(path);
    if (!await file.exists()) return 'missing';
    final extension = path.split('.').last.toLowerCase();
    if (!extensions.contains(extension)) return 'type';
    if (await file.length() > maxBytes) return 'size';
    final header = await file
        .openRead(0, 12)
        .fold<List<int>>([], (a, b) => a..addAll(b));
    if (!_matchesSignature(extension, header)) return 'type';
    return null;
  }

  static bool _matchesSignature(String extension, List<int> bytes) {
    if (extension == 'png') {
      return bytes.length >= 4 &&
          bytes[0] == 0x89 &&
          bytes[1] == 0x50 &&
          bytes[2] == 0x4e &&
          bytes[3] == 0x47;
    }
    if (extension == 'jpg' || extension == 'jpeg') {
      return bytes.length >= 3 &&
          bytes[0] == 0xff &&
          bytes[1] == 0xd8 &&
          bytes[2] == 0xff;
    }
    return bytes.length >= 12 &&
        String.fromCharCodes(bytes.sublist(0, 4)) == 'RIFF' &&
        String.fromCharCodes(bytes.sublist(8, 12)) == 'WEBP';
  }
}
