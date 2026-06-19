import 'package:bnan_app/features/teacher_assignment/data/teacher_assignment_filter_type.dart';


class TeacherAssignmentModel {
  const TeacherAssignmentModel({
    required this.title,
    required this.className,
    required this.subject,
    required this.description,
    required this.date,
    required this.studentsCount,
    required this.status,
  });

  final String title;
  final String className;
  final String subject;
  final String description;
  final String date;
  final String studentsCount;
  final TeacherAssignmentStatus status;
}


  final List<TeacherAssignmentModel> assignments = const [
    TeacherAssignmentModel(
      title: 'تمارين الجمع والطرح',
      className: 'الصف الثالث',
      subject: 'رياضيات',
      description: 'حل التمارين من صفحة 45 إلى 48',
      date: '1/6/2026',
      studentsCount: '18/25',
      status: TeacherAssignmentStatus.active,
    ),
    TeacherAssignmentModel(
      title: 'مسائل الضرب',
      className: 'الصف الرابع',
      subject: 'رياضيات',
      description: 'حل جميع مسائل الفصل الرابع',
      date: '2/6/2026',
      studentsCount: '28/28',
      status: TeacherAssignmentStatus.finished,
    ),
    TeacherAssignmentModel(
      title: 'العدد حتى 100',
      className: 'الصف الأول',
      subject: 'حساب',
      description: 'ورقة عمل العدد التصاعدي والتنازلي',
      date: '13/6/2026',
      studentsCount: '5/20',
      status: TeacherAssignmentStatus.notSubmitted,
    ),
    TeacherAssignmentModel(
      title: 'جدول الضرب',
      className: 'الصف الثالث',
      subject: 'رياضيات',
      description: 'حفظ جدول الضرب 2 و 3 و 4',
      date: '15/6/2026',
      studentsCount: '14/25',
      status: TeacherAssignmentStatus.submitted,
    ),
  ];
