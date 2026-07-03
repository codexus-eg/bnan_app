class TeacherApplicationModel {
  final int id;
  final String teacherName;
  final String phone;
  final String specialization;
  final List<String> subjects;
  final String experienceYears;
  final String status;
  final String? cvUrl;

  const TeacherApplicationModel({
    required this.id,
    required this.teacherName,
    required this.phone,
    required this.specialization,
    required this.subjects,
    required this.experienceYears,
    required this.status,
    this.cvUrl,
  });
}

const List<TeacherApplicationModel> teacherApplicationsMockData = [
  TeacherApplicationModel(
    id: 1,
    teacherName: 'سارة أحمد',
    phone: '010111123655',
    specialization: 'لغة عربية',
    subjects: ['لغة عربية', 'تربية دينية', 'تربية إسلامية'],
    experienceYears: '3 سنوات',
    status: 'قيد المراجعة',
    cvUrl: null,
  ),
  TeacherApplicationModel(
    id: 2,
    teacherName: 'سارة أحمد',
    phone: '010111123655',
    specialization: 'لغة عربية',
    subjects: ['لغة عربية', 'تربية دينية', 'تربية إسلامية'],
    experienceYears: '3 سنوات',
    status: 'قيد المراجعة',
    cvUrl: null,
  ),
  TeacherApplicationModel(
    id: 3,
    teacherName: 'سارة أحمد',
    phone: '010111123655',
    specialization: 'لغة عربية',
    subjects: ['لغة عربية', 'تربية دينية', 'تربية إسلامية'],
    experienceYears: '3 سنوات',
    status: 'قيد المراجعة',
    cvUrl: null,
  ),
];
