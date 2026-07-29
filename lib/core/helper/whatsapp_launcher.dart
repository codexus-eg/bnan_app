import 'package:bnan_app/core/helper/file_url_launcher.dart';

class WhatsAppLauncher {
  const WhatsAppLauncher._();

  static String normalizeEgyptPhoneNumber(String phoneNumber) {
    final digits = phoneNumber.trim().replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('0')) return '20${digits.substring(1)}';
    return digits;
  }

  static Future<bool> open(String phoneNumber) {
    final normalizedPhone = normalizeEgyptPhoneNumber(phoneNumber);
    if (normalizedPhone.isEmpty) return Future.value(false);

    return FileUrlLauncher.open('https://wa.me/$normalizedPhone');
  }
}
