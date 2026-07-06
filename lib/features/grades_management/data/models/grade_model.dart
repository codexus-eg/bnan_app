class GradeModel {
  const GradeModel({
    required this.id,
    required this.name,
    required this.curriculm,
  });

  final String id;
  final String name;
  final String curriculm;
}
const List<GradeModel> gradeMockData = [
  GradeModel(
    id: '1',
    name: 'الصف الرابع الإبتدائي',
    curriculm: 'مصري',
  ),
  GradeModel(
    id: '2',
    name: 'الصف الثالث الإبتدائي',
    curriculm: 'سعودي',
  ),
  GradeModel(
    id: '3',
    name: 'الصف الأول الإبتدائي',
    curriculm: 'سعودي',
  ),
  GradeModel(
    id: '4',
    name: 'الصف الثاني الإعدادي',
    curriculm: 'سعودي',
  ),
  GradeModel(
    id: '5',
    name: 'الصف الأول الثانوي',
    curriculm: 'مصري',
  ),
];