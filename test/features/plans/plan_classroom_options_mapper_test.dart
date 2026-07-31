import 'package:bnan_app/features/plans/presentation/mappers/plan_classroom_options_mapper.dart';
import 'package:bnan_app/features/student_groups/data/models/student_enrollment_model.dart';
import 'package:bnan_app/features/supervisor_management/data/models/supervisor_classroom_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_class_room_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('teacher mapper removes empty and duplicate classroom ids', () {
    final result = mapTeacherClassroomsToPlanOptions(const [
      TeacherClassroomModel(id: '1', name: 'First'),
      TeacherClassroomModel(id: '', name: 'Empty'),
      TeacherClassroomModel(id: '1', name: 'Updated'),
    ]);

    expect(result, hasLength(1));
    expect(result.single.name, 'Updated');
  });

  test('student mapper includes approved unique classrooms only', () {
    final result = mapStudentEnrollmentsToPlanOptions([
      _enrollment('1', 'approved'),
      _enrollment('1', 'approved'),
      _enrollment('2', 'pending'),
      _enrollment('', 'approved'),
    ]);

    expect(result.map((item) => item.id), ['1']);
  });

  test('supervisor mapper uses response classroom ids and names', () {
    final result = mapSupervisorClassroomsToPlanOptions(const [
      SupervisorClassroomModel(id: '3', name: 'Third'),
    ]);

    expect(result.single.id, '3');
    expect(result.single.name, 'Third');
  });
}

StudentEnrollmentModel _enrollment(String classroomId, String status) {
  return StudentEnrollmentModel(
    id: '$classroomId-$status',
    classroom: EnrollmentClassroomModel(id: classroomId, name: 'Class'),
    status: status,
    joinedAt: '',
    createdAt: '',
    updatedAt: '',
  );
}
