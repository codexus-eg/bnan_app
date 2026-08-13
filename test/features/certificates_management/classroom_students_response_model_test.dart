import 'package:bnan_app/features/certificates_management/data/models/classroom_students_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses studentId from the classroom roster response', () {
    final student = ClassroomStudentModel.fromJson({
      'studentId': '6a65349c2796ce31be8b9d7c',
      'fullName': 'Gulf Test Student',
    });

    expect(student.id, '6a65349c2796ce31be8b9d7c');
    expect(student.fullName, 'Gulf Test Student');
  });

  test('keeps compatibility with id and _id', () {
    expect(ClassroomStudentModel.fromJson({'id': 'student-1'}).id, 'student-1');
    expect(
      ClassroomStudentModel.fromJson({'_id': 'student-2'}).id,
      'student-2',
    );
  });
}
