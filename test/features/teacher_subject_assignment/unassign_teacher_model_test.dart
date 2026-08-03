import 'package:bnan_app/features/teacher_subject_assignment/data/models/unassign_teacher_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses teacher unassign response and maps API identifiers', () {
    final response = UnassignTeacherResponseModel.fromJson({
      'success': true,
      'data': {
        'teacher': 'teacher-1',
        'classroom': 'classroom-1',
        'deactivatedAssignments': 1,
      },
    });

    expect(response.success, isTrue);
    expect(response.data?.teacherId, 'teacher-1');
    expect(response.data?.classroomId, 'classroom-1');
    expect(response.data?.deactivatedAssignments, 1);
  });

  test('parses numeric and numeric-string deactivated counts safely', () {
    for (final entry in [(2.8, 2), ('3', 3), ('invalid', 0)]) {
      final response = UnassignTeacherResponseModel.fromJson({
        'data': {'deactivatedAssignments': entry.$1},
      });
      expect(response.data?.deactivatedAssignments, entry.$2);
    }
  });

  test('missing or invalid data is nullable and does not throw', () {
    expect(UnassignTeacherResponseModel.fromJson({}).data, isNull);
    expect(
      UnassignTeacherResponseModel.fromJson({'data': 'invalid'}).data,
      isNull,
    );
    expect(UnassignTeacherResponseModel.fromJson({}).success, isFalse);
  });
}
