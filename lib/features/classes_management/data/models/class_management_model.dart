class ClassManagementModel {
  const ClassManagementModel({
    required this.title,
    required this.curriculum,
    required this.grade,
    required this.teachers,
    required this.studentsCount,
    required this.supervisor,
  });

  final String title;
  final String curriculum;
  final String grade;
  final String teachers;
  final int studentsCount;
  final String supervisor;
}

const List<ClassManagementModel> classManagementMockData = [
  ClassManagementModel(
    title: 'الصف الثالث الإعدادي - لغات (Prep 3)',
    curriculum: 'المنهج السعودي',
    grade: 'الصف الأول',
    teachers: 'مدير أحمد',
    studentsCount: 25,
    supervisor: 'نورا أحمد',
  ),
  ClassManagementModel(
    title: 'الصف الثالث المتوسط - السعودي',
    curriculum: 'المنهج السعودي',
    grade: 'الصف الأول المتوسط',
    teachers: 'مدير أحمد - حصة الجباني',
    studentsCount: 10,
    supervisor: '-',
  ),
  ClassManagementModel(
    title: 'الصف الثالث الإعدادي - لغات (Prep 3)',
    curriculum: 'المنهج السعودي',
    grade: 'الصف الأول',
    teachers: 'مدير أحمد',
    studentsCount: 25,
    supervisor: 'نورا أحمد',
  ),
];