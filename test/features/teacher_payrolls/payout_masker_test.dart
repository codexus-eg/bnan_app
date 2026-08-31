import 'package:bnan_app/features/teacher_payrolls/presentation/utils/payout_masker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('masks payout values for read-only display', () {
    expect(PayoutMasker.accountNumber('1234567890'), '•••• 7890');
    expect(PayoutMasker.iban('eg12 3456 7890'), 'EG12 •••• 7890');
    expect(PayoutMasker.walletPhone('01012345678'), '010••••••78');
  });
}
