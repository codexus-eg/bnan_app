import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/student_auth/data/models/auth_response_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final session = SessionManager.instance;

  for (final testCase in <(List<String>, bool, bool)>[
    (['egyptian'], true, false),
    (['gulf'], false, true),
    (['egyptian', 'gulf'], true, true),
  ]) {
    test('stores root registrationModes ${testCase.$1}', () async {
      FlutterSecureStorage.setMockInitialValues({});
      await session.clearSession();
      final response = AuthResponseModel.fromJson({
        'success': true,
        'token': 'token',
        'registrationModes': testCase.$1,
        'data': {
          'user': {'id': 'teacher-id', 'role': 'teacher'},
        },
      });

      await session.saveSession(
        accessToken: response.token,
        refreshToken: '',
        userRole: response.user.role,
        registrationModes: response.user.registrationModes,
      );

      expect(session.hasEgyptianRegistration, testCase.$2);
      expect(session.hasGulfRegistration, testCase.$3);
    });
  }

  test('pending Egyptian registration with empty subscriptions is success', () {
    final response = AuthResponseModel.fromJson({
      'success': true,
      'data': {
        'user': {'id': 'student-id', 'role': 'student'},
        'registrationRequestId': 'request-id',
        'registrationStatus': 'pending',
        'paymentStatus': 'pending',
        'paymentId': 'payment-id',
        'paymentItems': [
          {
            'subject': {'id': 'math-id', 'name': 'Math'},
            'package': {'id': 'package-id', 'name': '8 Hours'},
          },
        ],
        'subscriptions': <Object?>[],
        'subscription': {'id': 'legacy-must-not-be-used'},
      },
    });

    expect(response.success, isTrue);
    expect(response.registrationRequestId, 'request-id');
    expect(response.registrationStatus, 'pending');
    expect(response.paymentStatus, 'pending');
    expect(response.paymentId, 'payment-id');
    expect(response.paymentItems, hasLength(1));
    expect(response.subscriptions, isEmpty);
  });

  test('registration response parses every subscription independently', () {
    final response = AuthResponseModel.fromJson({
      'success': true,
      'subscriptions': [
        {'id': 'math-sub', 'remainingHours': 2},
        {'id': 'english-sub', 'remainingHours': 5},
        {'id': 'arabic-sub', 'remainingHours': 8},
      ],
    });

    expect(response.subscriptions.map((item) => item.id), [
      'math-sub',
      'english-sub',
      'arabic-sub',
    ]);
    expect(response.subscriptions.map((item) => item.remainingHours), [
      2,
      5,
      8,
    ]);
  });
}
