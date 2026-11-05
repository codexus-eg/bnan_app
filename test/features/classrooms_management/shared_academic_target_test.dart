import 'package:bnan_app/features/classrooms_management/data/models/classroom_request_model.dart';
import 'package:bnan_app/features/classrooms_management/data/models/shared_academic_target.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SharedAcademicTarget Parsing & Serialization', () {
    test('parses when grade is a raw String id', () {
      final json = {'curriculum': 'curr_123', 'grade': 'grade_456'};
      final target = SharedAcademicTarget.fromJson(json);

      expect(target.curriculum, 'curr_123');
      expect(target.grade, 'grade_456');
      expect(target.gradeName, isNull);
      expect(target.toJson(), {'curriculum': 'curr_123', 'grade': 'grade_456'});
    });

    test('parses when grade is an Object Map with id and name', () {
      final json = {
        'curriculum': 'curr_123',
        'grade': {'_id': 'grade_789', 'name': 'First Grade Primary'},
      };
      final target = SharedAcademicTarget.fromJson(json);

      expect(target.curriculum, 'curr_123');
      expect(target.grade, 'grade_789');
      expect(target.gradeName, 'First Grade Primary');
      expect(target.toJson(), {'curriculum': 'curr_123', 'grade': 'grade_789'});
    });

    test('handles fallback when grade object uses "id" key', () {
      final json = {
        'curriculum': 'curr_123',
        'grade': {'id': 'grade_abc', 'name': 'Second Grade'},
      };
      final target = SharedAcademicTarget.fromJson(json);

      expect(target.grade, 'grade_abc');
      expect(target.gradeName, 'Second Grade');
    });
  });

  group('ClassroomRequestModel Shared Classroom serialization', () {
    test('serializes shared classroom payload omitting meetingLink', () {
      final request = ClassroomRequestModel(
        name: 'Shared Room 1',
        curriculumId: 'curr_eg',
        gradeId: 'grade_1',
        supervisorId: 'sup_99',
        meetingLink: 'https://zoom.us/j/12345',
        classroomKind: 'shared',
        sharedAcademicTargets: const [
          SharedAcademicTarget(curriculum: 'curr_eg', grade: 'grade_1'),
          SharedAcademicTarget(curriculum: 'curr_eg', grade: 'grade_2'),
        ],
        subjects: ['sub_a', 'sub_b'],
      );

      final json = request.toJson();
      expect(json['name'], 'Shared Room 1');
      expect(json['curriculum'], 'curr_eg');
      expect(json['grade'], 'grade_1');
      expect(json['supervisorId'], 'sup_99');
      expect(json['classroomKind'], 'shared');
      expect(json.containsKey('meetingLink'), isFalse);
      expect(json['sharedAcademicTargets'], [
        {'curriculum': 'curr_eg', 'grade': 'grade_1'},
        {'curriculum': 'curr_eg', 'grade': 'grade_2'},
      ]);
      expect(json['subjects'], ['sub_a', 'sub_b']);
    });

    test('serializes standard classroom omitting empty meetingLink', () {
      const request = ClassroomRequestModel(
        name: 'Standard Room',
        curriculumId: 'curr_gulf',
        gradeId: 'grade_g1',
        supervisorId: 'sup_1',
        meetingLink: '   ',
      );

      final json = request.toJson();
      expect(json['name'], 'Standard Room');
      expect(json.containsKey('meetingLink'), isFalse);
      expect(json.containsKey('classroomKind'), isFalse);
      expect(json.containsKey('sharedAcademicTargets'), isFalse);
    });
  });
}
