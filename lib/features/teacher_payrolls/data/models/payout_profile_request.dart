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
  bool get isValid =>
      accountHolderName.trim().isNotEmpty &&
      switch (method) {
        PayoutMethod.instapay => instapayAddress.trim().isNotEmpty,
        PayoutMethod.wallet =>
          const {
                'vodafone_cash',
                'orange_cash',
                'etisalat_cash',
                'we_pay',
                'other',
              }.contains(walletProvider.trim()) &&
              RegExp(r'^01[0125]\d{8}$').hasMatch(walletPhone.trim()),
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
      'walletPhone': walletPhone.trim(),
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
