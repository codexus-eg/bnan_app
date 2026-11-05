import 'package:bnan_app/features/lessons_management/data/models/course_schedule_payloads.dart';
import 'package:bnan_app/features/lessons_management/data/models/course_schedule_slot.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CourseScheduleModels', () {
    test('CourseScheduleSlot fromJson and toJson', () {
      final json = {
        'slotId': 'csl_123',
        'day': 'saturday',
        'startTime': '08:55',
        'endTime': '10:56',
        'subjectId': 'sub_1',
      };
      final slot = CourseScheduleSlot.fromJson(json);
      expect(slot.slotId, 'csl_123');
      expect(slot.day, 'saturday');
      expect(slot.startTime, '08:55');
      expect(slot.endTime, '10:56');
      expect(slot.subjectId, 'sub_1');
      expect(slot.toJson(), {
        'slotId': 'csl_123',
        'day': 'saturday',
        'startTime': '08:55',
        'endTime': '10:56',
      });
    });

    test('CourseScheduleResponse parses nested data and slots', () {
      final json = {
        'success': true,
        'data': {
          'timezone': 'Africa/Cairo',
          'slots': [
            {
              'slotId': 'csl_sat_1',
              'day': 'saturday',
              'startTime': '08:55',
              'endTime': '10:56',
            },
          ],
        },
      };
      final res = CourseScheduleResponse.fromJson(json);
      expect(res.success, isTrue);
      expect(res.timezone, 'Africa/Cairo');
      expect(res.slots.length, 1);
      expect(res.slots.first.slotId, 'csl_sat_1');
    });

    test('GulfClassroom identifies course classroom properly', () {
      const course1 = GulfClassroom(
        id: 'c1',
        name: 'دورة تجريبيه - Group 5DA804',
      );
      expect(course1.isCourse, isTrue);

      const course2 = GulfClassroom(
        id: 'c2',
        name: 'General Classroom',
        classroomKind: 'course',
      );
      expect(course2.isCourse, isTrue);

      const regular = GulfClassroom(
        id: 'c3',
        name: 'Grade 10 Math',
        grade: GulfGrade(id: '10', name: '10'),
      );
      expect(regular.isCourse, isFalse);
    });
  });
}
