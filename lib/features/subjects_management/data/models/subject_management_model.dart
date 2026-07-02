class SubjectManagementModel {
  final String name;
  final String curriculum;
  final String grade;

  const SubjectManagementModel({
    required this.name,
    required this.curriculum,
    required this.grade,
  });
}

const List<SubjectManagementModel> subjectsMockData = [
  SubjectManagementModel(
    name: 'كيمياء',
    curriculum: 'المنهج السعودي',
    grade: 'الصف الأول',
  ),
  SubjectManagementModel(
    name: 'فيزياء',
    curriculum: 'المنهج المصري',
    grade: 'الصف الأول',
  ),
  SubjectManagementModel(
    name: 'English',
    curriculum: 'المنهج السعودي',
    grade: 'الصف الأول',
  ),
];