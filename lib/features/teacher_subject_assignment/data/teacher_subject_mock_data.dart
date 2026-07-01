class TeacherSubjectAssignmentItem {
  const TeacherSubjectAssignmentItem(this.teacherName, this.assignments);
  final String teacherName;
  final List<SubjectAssignmentItem> assignments;
}

class SubjectAssignmentItem {
  const SubjectAssignmentItem(
    this.subjectName,
    this.gradeName,
    this.curriculumName,
  );
  final String subjectName;
  final String gradeName;
  final String curriculumName;
}

const teacherSubjectAssignments = [
  TeacherSubjectAssignmentItem('مس سارة أحمد', [
    SubjectAssignmentItem('Math', 'الصف الرابع الإبتدائي', 'مصري'),
    SubjectAssignmentItem('Math', 'الصف الرابع الإبتدائي', 'سعودي'),
    SubjectAssignmentItem('Math', 'الصف الرابع الإبتدائي', 'مصري'),
  ]),
  TeacherSubjectAssignmentItem('مس سهيلة', [
    SubjectAssignmentItem('English', 'الصف الثاني الثانوي', 'مصري'),
    SubjectAssignmentItem('English', 'الصف الثاني الثانوي', 'سعودي'),
  ]),
  TeacherSubjectAssignmentItem('مستر عبدالفتاح', [
    SubjectAssignmentItem('الرياضيات', 'الصف الثاني الثانوي', 'مصري'),
  ]),
];
