class ClassroomModel {
  const ClassroomModel({
    required this.id,
    required this.name,
    required this.curriculm,
  });

  final String id;
  final String name;
  final String curriculm;
}
const List<ClassroomModel> classRoomMockData = [
  ClassroomModel(
    id: '1',
    name: 'الصف الرابع الإبتدائي',
    curriculm: 'مصري',
  ),
  ClassroomModel(
    id: '2',
    name: 'الصف الثالث الإبتدائي',
    curriculm: 'سعودي',
  ),
  ClassroomModel(
    id: '3',
    name: 'الصف الأول الإبتدائي',
    curriculm: 'سعودي',
  ),
  ClassroomModel(
    id: '4',
    name: 'الصف الثاني الإعدادي',
    curriculm: 'سعودي',
  ),
  ClassroomModel(
    id: '5',
    name: 'الصف الأول الثانوي',
    curriculm: 'مصري',
  ),
];