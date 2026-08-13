import 'package:bnan_app/features/shared_profile/data/models/logged_user_model.dart';
import 'package:bnan_app/features/shared_profile/data/models/teacher_profile_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parent profile parses the parent identity instead of child data', () {
    final parent = LoggedUserModel.fromJson({
      'id': 'parent-profile',
      'fullName': 'Parent Person',
      'email': 'parent@bnan.test',
      'phone': '+20100',
      'role': 'parent',
      'children': [
        {'fullName': 'Child Person'},
      ],
    });

    expect(parent.user.fullName, 'Parent Person');
    expect(parent.user.phone, '+20100');
    expect(parent.user.fullName, isNot('Child Person'));
  });

  test('student optional academic fields and object subjects parse safely', () {
    final student = LoggedUserModel.fromJson({
      'user': {'fullName': 'Student', 'role': 'student'},
      'curriculum': {'id': 'c1', 'name': 'Egyptian'},
      'grade': {'id': 'g1', 'name': 'Grade 1'},
      'subjects': [
        {'id': 's1', 'name': 'Math'},
      ],
      'registrationMode': 'egyptian',
    });

    expect(student.curriculumName, 'Egyptian');
    expect(student.grade?.name, 'Grade 1');
    expect(student.subjects, ['Math']);
    expect(student.studentMode, 'egyptian');
  });

  test('teacher arrays map to role-specific profile counts and names', () {
    final teacher = TeacherProfileModel.fromJson({
      'user': {'fullName': 'Teacher', 'email': 'teacher@bnan.test'},
      'curriculums': [
        {'id': 'c1', 'name': 'Gulf'},
      ],
      'grades': [
        {'id': 'g1'},
        {'id': 'g2'},
      ],
      'subjects': [
        {'id': 's1', 'name': 'Math'},
      ],
    });

    expect(teacher.grades, 2);
    expect(teacher.curriculums.single.name, 'Gulf');
    expect(teacher.subjects.single.name, 'Math');
  });
}
