class ClassScheduleModel {
  final String imagePath;
  final String curriculum;
  final String grade;
  final String subject;
  final String fileName;

  const ClassScheduleModel({
    required this.imagePath,
    required this.curriculum,
    required this.grade,
    required this.subject,
    required this.fileName,
  });
}

const List<ClassScheduleModel> classSchedulesMockData = [
  ClassScheduleModel(
    imagePath: 'assets/images/teacher_home/IMG-20260603-WA0030 2.png',
    curriculum: 'المنهج المصري',
    grade: 'الصف الأول الإعدادي',
    subject: 'عربي',
    fileName: 'جدول الصف الأول الإعدادي عربي',
  ),
  ClassScheduleModel(
    imagePath: 'assets/images/teacher_home/IMG-20260603-WA0030 2.png',
    curriculum: 'المنهج المصري',
    grade: 'الصف الأول الإعدادي',
    subject: 'عربي',
    fileName: 'جدول الصف الأول الإعدادي عربي',
  ),
  ClassScheduleModel(
    imagePath: 'assets/images/teacher_home/IMG-20260603-WA0030 2.png',
    curriculum: 'المنهج المصري',
    grade: 'الصف الأول الإعدادي',
    subject: 'عربي',
    fileName: 'جدول الصف الأول الإعدادي عربي',
  ),
  ClassScheduleModel(
    imagePath: 'assets/images/teacher_home/IMG-20260603-WA0030 2.png',
    curriculum: 'المنهج المصري',
    grade: 'الصف الأول الإعدادي',
    subject: 'عربي',
    fileName: 'جدول الصف الأول الإعدادي عربي',
  ),
];
