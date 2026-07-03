import 'package:bnan_app/features/teacher_application/data/models/teacher_application_details_model.dart';

const teacherApplicationDetailsMockData = <int, TeacherApplicationDetailsModel>{
  1: _details,
  2: _details,
  3: _details,
};

const _details = TeacherApplicationDetailsModel(
  city: 'القاهرة',
  whatsapp: '010111123655',
  country: 'مصر',
  nationality: 'مصرية',
  birthDate: '1996/05/12',
  graduationYear: '2018',
  major: 'لغة عربية',
  university: 'جامعة القاهرة',
  graduationGrade: 'جيد جدًا',
  qualification: 'ليسانس آداب وتربية',
  hasOnlineExperience: true,
  gradeLevel: 'المرحلة الإعدادية',
  platformsUsed: 'Zoom، Google Meet',
  hasExperience: true,
  taughtSubjects: 'لغة عربية، تربية إسلامية',
  weeklyHours: '12 ساعة',
  curriculum: 'المنهج المصري',
  desiredSubjects: 'لغة عربية',
  availability: 'الأحد والثلاثاء من 6 إلى 9 مساءً',
  teachableGrades: 'الأول الإعدادي، الثاني الإعدادي',
  hasCamera: true,
  hasMic: true,
  hasInternet: true,
  hasLaptop: true,
  computerLevel: 'جيد جدًا',
  demoVideoUrl: 'https://example.com/demo-video',
  canDemo: true,
  weakStudentApproach: 'أقسم المهارة إلى خطوات قصيرة مع تدريبات متدرجة.',
  whyJoin: 'أرغب في تقديم تجربة تعليمية منظمة ومفيدة للطلاب.',
);
