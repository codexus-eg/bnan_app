import 'package:bnan_app/features/ideal_teacher/data/models/ideal_teacher_parser.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/supervisor_teacher_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses nested teacher and mixed relation shapes safely', () {
    final teacher = SupervisorTeacherModel.fromJson({
      'teacher': {
        'id': 't1',
        'user': {'fullName': 'Ahmed', 'avatar': 'image'},
        'subjects': [
          'Math',
          {'name': 'Physics'},
        ],
        'classrooms': [
          {'title': '1/A'},
          '2/B',
        ],
      },
    });
    expect(teacher.id, 't1');
    expect(teacher.name, 'Ahmed');
    expect(teacher.avatar, 'image');
    expect(teacher.subjects, ['Math', 'Physics']);
    expect(teacher.classrooms, ['1/A', '2/B']);
  });

  test('accepts direct and nested response lists', () {
    expect(
      IdealTeacherParser.responseItems({
        'data': [1],
      }),
      [1],
    );
    expect(
      IdealTeacherParser.responseItems({
        'data': {
          'teachers': [2],
        },
      }),
      [2],
    );
    expect(IdealTeacherParser.responseItems(null), isEmpty);
  });
}
