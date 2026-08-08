import 'payroll_parsing.dart';

class PayoutProfileModel {
  const PayoutProfileModel({
    required this.method,
    required this.accountHolderName,
    required this.instapayAddress,
    required this.walletProvider,
    required this.walletPhone,
    required this.bankName,
    required this.accountNumber,
    required this.iban,
    required this.updatedAt,
  });
  final String method, accountHolderName, instapayAddress;
  final String walletProvider, walletPhone, bankName, accountNumber, iban;
  final String updatedAt;

  factory PayoutProfileModel.fromJson(Object? value) {
    final json = payrollMap(value);
    return PayoutProfileModel(
      method: payrollString(json['method']),
      accountHolderName: payrollString(json['accountHolderName']),
      instapayAddress: payrollString(json['instapayAddress']),
      walletProvider: payrollString(json['walletProvider']),
      walletPhone: payrollString(json['walletPhone']),
      bankName: payrollString(json['bankName']),
      accountNumber: payrollString(json['accountNumber']),
      iban: payrollString(json['iban']),
      updatedAt: payrollString(json['updatedAt']),
    );
  }
}
