import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/features/ideal_student/presentation/policies/ideal_student_access_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  bool access(
    UserRole role, {
    RegistrationMode? mode,
    List<RegistrationMode> modes = const [],
  }) => IdealStudentAccessPolicy.canAccess(
    role: role,
    registrationMode: mode,
    registrationModes: modes,
  );

  test('teacher requires Egyptian access and mixed is allowed', () {
    expect(
      access(UserRole.teacher, modes: [RegistrationMode.egyptian]),
      isTrue,
    );
    expect(access(UserRole.teacher, modes: RegistrationMode.values), isTrue);
    expect(access(UserRole.teacher, modes: [RegistrationMode.gulf]), isFalse);
    expect(access(UserRole.teacher), isFalse);
  });

  test('supervisor requires explicit Egyptian mode', () {
    expect(
      access(UserRole.supervisor, mode: RegistrationMode.egyptian),
      isTrue,
    );
    expect(access(UserRole.supervisor, mode: RegistrationMode.gulf), isFalse);
    expect(access(UserRole.supervisor), isFalse);
  });

  test('other roles are blocked', () {
    for (final role in [UserRole.admin, UserRole.student, UserRole.parent]) {
      expect(
        access(
          role,
          mode: RegistrationMode.egyptian,
          modes: [RegistrationMode.egyptian],
        ),
        isFalse,
      );
    }
  });
}
