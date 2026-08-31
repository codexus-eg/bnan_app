abstract class PayoutMasker {
  static String accountNumber(String value) {
    final compact = value.replaceAll(RegExp(r'\s+'), '');
    if (compact.length <= 4) return compact;
    return '•••• ${compact.substring(compact.length - 4)}';
  }

  static String iban(String value) {
    final compact = value.replaceAll(RegExp(r'\s+'), '').toUpperCase();
    if (compact.length <= 8) return compact;
    return '${compact.substring(0, 4)} •••• ${compact.substring(compact.length - 4)}';
  }

  static String walletPhone(String value) {
    final compact = value.replaceAll(RegExp(r'\s+'), '');
    if (compact.length <= 5) return compact;
    final hidden = '•' * (compact.length - 5);
    return '${compact.substring(0, 3)}$hidden${compact.substring(compact.length - 2)}';
  }
}
