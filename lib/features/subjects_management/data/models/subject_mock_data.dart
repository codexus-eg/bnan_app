import 'package:bnan_app/features/subjects_management/data/models/subject_response_model.dart';

final List<SubjectModel> mockSubjects = [
  SubjectModel(
    id: '1',
    name: 'كيمياء',
    isActive: true,
    curriculum: SubjectCurriculumModel(
      id: 'c1',
      name: 'المنهج السعودي',
      icon: '',
    ),
  ),
  SubjectModel(
    id: '2',
    name: 'فيزياء',
    isActive: true,
    curriculum: SubjectCurriculumModel(
      id: 'c2',
      name: 'المنهج المصري',
      icon: '',
    ),
  ),
  SubjectModel(
    id: '3',
    name: 'English',
    isActive: true,
    curriculum: SubjectCurriculumModel(
      id: 'c1',
      name: 'المنهج السعودي',
      icon: '',
    ),
  ),
];