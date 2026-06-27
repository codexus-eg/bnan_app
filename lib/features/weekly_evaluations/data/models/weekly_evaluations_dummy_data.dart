import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluation_model.dart';

const weeklyEvaluationsDummyData = [
  WeeklyEvaluationModel(
    studentName: 'شهد أحمد',
    classLabel: 'الصف الثالث الإعدادي',
    weekStart: '03/15/2026',
    previewImage: 'assets/images/teacher_home/IMG-20260603-WA0030 2.png',
    attendance: 'ممتاز',
    participation: 'جيد جدًا',
    assignments: 'ممتاز',
    behavior: 'ممتاز',
    notes: 'تقدم ملحوظ هذا الأسبوع.',
  ),
  WeeklyEvaluationModel(
    studentName: 'محمد جمال',
    classLabel: 'الصف الثاني الإعدادي',
    weekStart: '03/08/2026',
    previewImage: 'assets/images/teacher_home/IMG-20260603-WA0030 2.png',
    attendance: 'جيد',
    participation: 'ممتاز',
    assignments: 'جيد جدًا',
    behavior: 'ممتاز',
    notes: 'يحتاج متابعة الواجبات.',
  ),
];
