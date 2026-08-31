enum PayoutMethod {
  wallet('wallet'),
  bankAccount('bank_account'),
  instapay('instapay');

  const PayoutMethod(this.apiValue);

  final String apiValue;

  static PayoutMethod fromApi(String value) => switch (value) {
    'wallet' => wallet,
    'bank_account' => bankAccount,
    _ => instapay,
  };
}
