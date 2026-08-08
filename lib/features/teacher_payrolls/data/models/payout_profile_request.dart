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
  final String method, accountHolderName, instapayAddress;
  final String walletProvider, walletPhone, bankName, accountNumber, iban;
  PayoutProfileRequest withMethod(String value) =>
      PayoutProfileRequest(method: value, accountHolderName: accountHolderName);
  bool get isValid =>
      accountHolderName.trim().isNotEmpty &&
      switch (method) {
        'instapay' => instapayAddress.trim().isNotEmpty,
        'wallet' =>
          walletProvider.trim().isNotEmpty && walletPhone.trim().isNotEmpty,
        'bank_account' =>
          bankName.trim().isNotEmpty &&
              (accountNumber.trim().isNotEmpty || iban.trim().isNotEmpty),
        _ => false,
      };
  Map<String, dynamic> toJson() => {
    'method': method,
    'accountHolderName': accountHolderName.trim(),
    if (method == 'instapay') 'instapayAddress': instapayAddress.trim(),
    if (method == 'wallet') ...{
      'walletProvider': walletProvider.trim(),
      'walletPhone': walletPhone.trim(),
    },
    if (method == 'bank_account') ...{
      'bankName': bankName.trim(),
      if (accountNumber.trim().isNotEmpty)
        'accountNumber': accountNumber.trim(),
      if (iban.trim().isNotEmpty) 'iban': iban.trim().toUpperCase(),
    },
  };
}
