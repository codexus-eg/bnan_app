import 'payout_method.dart';

class PayoutProfileRequest {
  const PayoutProfileRequest({
    required this.method,
    required this.accountHolderName,
    this.instapayAddress = '',
    this.walletProvider = '',
    this.walletPhone = '',
    this.bankName = '',
    this.accountNumber = '',
    this.iban = '',
  });
  final PayoutMethod method;
  final String accountHolderName, instapayAddress;
  final String walletProvider, walletPhone, bankName, accountNumber, iban;
  PayoutProfileRequest withMethod(PayoutMethod value) =>
      PayoutProfileRequest(method: value, accountHolderName: accountHolderName);
  static bool isValidWalletPhone(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (cleaned.isEmpty) return false;
    final eg = RegExp(r'^(?:\+20|0020|20)?0?1[0125]\d{8}$');
    final sa = RegExp(r'^(?:\+966|00966|966)?0?5\d{8}$');
    final general = RegExp(r'^\+?[0-9]{8,15}$');
    return eg.hasMatch(cleaned) || sa.hasMatch(cleaned) || general.hasMatch(cleaned);
  }

  static String formatWalletPhone(String raw) {
    var cleaned = raw.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (RegExp(r'^(?:\+20|0020|20)1[0125]\d{8}$').hasMatch(cleaned)) {
      if (cleaned.startsWith('+20')) {
        cleaned = '0${cleaned.substring(3)}';
      } else if (cleaned.startsWith('0020')) {
        cleaned = '0${cleaned.substring(4)}';
      } else if (cleaned.startsWith('20')) {
        cleaned = '0${cleaned.substring(2)}';
      }
    }
    return cleaned;
  }

  bool get isValid =>
      accountHolderName.trim().isNotEmpty &&
      switch (method) {
        PayoutMethod.instapay => instapayAddress.trim().isNotEmpty,
        PayoutMethod.wallet =>
          walletProvider.trim().isNotEmpty && isValidWalletPhone(walletPhone),
        PayoutMethod.bankAccount =>
          bankName.trim().isNotEmpty &&
              (accountNumber.trim().isNotEmpty || iban.trim().isNotEmpty),
      };
  Map<String, dynamic> toJson() => {
    'method': method.apiValue,
    'accountHolderName': accountHolderName.trim(),
    if (method == PayoutMethod.instapay)
      'instapayAddress': instapayAddress.trim(),
    if (method == PayoutMethod.wallet) ...{
      'walletProvider': walletProvider.trim(),
      'walletPhone': formatWalletPhone(walletPhone),
    },
    if (method == PayoutMethod.bankAccount) ...{
      'bankName': bankName.trim(),
      if (accountNumber.trim().isNotEmpty)
        'accountNumber': accountNumber.trim(),
      if (iban.trim().isNotEmpty)
        'iban': iban.replaceAll(RegExp(r'\s+'), '').toUpperCase(),
    },
  };
}
