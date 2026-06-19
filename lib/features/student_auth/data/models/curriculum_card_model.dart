import 'package:bnan_app/features/student_auth/data/models/curriculum_model.dart';

class CurriculumCardModel {
  final String id;
  final String title;
  final String description;
  final String iconUrl;

  const CurriculumCardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconUrl,
  });

  factory CurriculumCardModel.fromCurriculum(CurriculumModel curriculum) {
    return CurriculumCardModel(
      id: curriculum.id,
      title: curriculum.name,
      description: curriculum.description,
      iconUrl:curriculum.icon,
    );
  }

  static List<CurriculumCardModel> placeholderList() {
    return const [
      CurriculumCardModel(
        id: '',
        title: 'المنهج الدراسي',
        description: 'وصف مختصر للمنهج الدراسي يظهر هنا',
        iconUrl: '',
      ),
      CurriculumCardModel(
        id: '',
        title: 'المنهج الدراسي',
        description: 'وصف مختصر للمنهج الدراسي يظهر هنا',
        iconUrl: '',
      ),
      CurriculumCardModel(
        id: '',
        title: 'المنهج الدراسي',
        description: 'وصف مختصر للمنهج الدراسي يظهر هنا',
        iconUrl: '',
      ),
    ];
  }
}