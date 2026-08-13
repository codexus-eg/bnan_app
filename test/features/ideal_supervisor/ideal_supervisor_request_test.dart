import 'package:bnan_app/features/ideal_supervisor/data/models/ideal_supervisor_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('serializes one supervisor with signer and no extra fields', () {
    const request = IdealSupervisorRequest(
      supervisorIds: ['sup-1'],
      signerName: ' Admin Name ',
    );
    expect(request.toJson(), {
      'supervisorIds': ['sup-1'],
      'signerName': 'Admin Name',
    });
    expect(request.toJson().keys, hasLength(2));
  });

  test('serializes multiple supervisor account ids', () {
    const request = IdealSupervisorRequest(
      supervisorIds: ['sup-1', 'sup-2'],
      signerName: 'Admin Name',
    );
    expect(request.toJson()['supervisorIds'], ['sup-1', 'sup-2']);
  });
}
