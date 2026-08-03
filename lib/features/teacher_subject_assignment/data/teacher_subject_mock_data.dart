import 'package:bnan_app/features/teacher_subject_assignment/data/models/assignment_row_item.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/views/widgets/teacher_subject_assignment_card_item.dart';

final List<TeacherSubjectAssignmentCardItem> teacherSubjectMockData = [
  TeacherSubjectAssignmentCardItem(
    teacherId: '1',
    teacherName: 'أحمد محمد',
    rows: [
      AssignmentRowItem(
        subjectName: 'الرياضيات',
        gradeName: 'الصف الأول',
        curriculumName: 'المنهج المصري',
        classroomId: 'classroom-1',
        classroomName: '1 / A',
        assignmentId: 'assignment-1',
      ),
      AssignmentRowItem(
        subjectName: 'العلوم',
        gradeName: 'الصف الثاني',
        curriculumName: 'المنهج المصري',
        classroomId: 'classroom-2',
        classroomName: '2 / B',
        assignmentId: 'assignment-2',
      ),
    ],
  ),
  TeacherSubjectAssignmentCardItem(
    teacherId: '2',
    teacherName: 'سارة علي',
    rows: [
      AssignmentRowItem(
        subjectName: 'اللغة العربية',
        gradeName: 'الصف الثالث',
        curriculumName: 'المنهج السعودي',
        classroomId: 'classroom-3',
        classroomName: '3 / A',
        assignmentId: 'assignment-3',
      ),
    ],
  ),
];
