import 'package:bnan_app/features/teacher_payrolls/data/models/payout_method.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('changing method clears method-specific fields', () {
    const request = PayoutProfileRequest(
      method: PayoutMethod.wallet,
      accountHolderName: 'Ahmed',
      walletProvider: 'cash',
      walletPhone: '010',
    );
    final changed = request.withMethod(PayoutMethod.bankAccount);
    expect(changed.walletProvider, isEmpty);
    expect(changed.walletPhone, isEmpty);
  });

  test('bank requires account number or iban', () {
    expect(
      const PayoutProfileRequest(
        method: PayoutMethod.bankAccount,
        accountHolderName: 'A',
        bankName: 'CIB',
      ).isValid,
      isFalse,
    );
    expect(
      const PayoutProfileRequest(
        method: PayoutMethod.bankAccount,
        accountHolderName: 'A',
        bankName: 'CIB',
        accountNumber: '12',
      ).isValid,
      isTrue,
    );
    expect(
      const PayoutProfileRequest(
        method: PayoutMethod.bankAccount,
        accountHolderName: 'A',
        bankName: 'CIB',
        iban: 'eg 12',
      ).toJson()['iban'],
      'EG12',
    );
  });

  test('wallet validates provider and Egyptian wallet phone', () {
    expect(
      const PayoutProfileRequest(
        method: PayoutMethod.wallet,
        accountHolderName: 'A',
        walletProvider: 'vodafone_cash',
        walletPhone: '01012345678',
      ).isValid,
      isTrue,
    );
  });
}
