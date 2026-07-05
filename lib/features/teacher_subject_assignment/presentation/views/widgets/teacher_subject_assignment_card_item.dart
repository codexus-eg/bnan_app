import 'package:bnan_app/features/teacher_subject_assignment/data/models/assignment_row_item.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/teaching_assignments_response_model.dart';

class TeacherSubjectAssignmentCardItem {
  const TeacherSubjectAssignmentCardItem({
    required this.teacherId,
    required this.teacherName,
    required this.rows,
  });

  final String teacherId;
  final String teacherName;
  final List<AssignmentRowItem> rows;

  factory TeacherSubjectAssignmentCardItem.fromApiItem(
    TeachingAssignmentItem api,
  ) {
    return TeacherSubjectAssignmentCardItem(
      teacherId: api.teacher.id,
      teacherName: api.teacher.displayName,
      rows: api.assignmentRows
          .map(
            (row) => AssignmentRowItem(
              subjectName: row.subjectName,
              gradeName: row.gradeName,
              curriculumName: row.curriculumName,
              classroomName: row.classroomName,
              assignmentId: row.assignmentId,
            ),
          )
          .toList(),
    );
  }
}