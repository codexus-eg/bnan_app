import 'package:bnan_app/generated/l10n.dart';

class ParentChildModel {
  const ParentChildModel({
    required this.name,
    required this.grade,
  });

  final String name;
  final String grade;
}
 final children = [
      ParentChildModel(
        name: 'ليلى خالد',
        grade: S.current.parentFirstPreparatoryGrade,
      ),
      ParentChildModel(
        name: 'أحمد خالد',
        grade: S.current.parentSecondPreparatoryGrade,
      ),
      ParentChildModel(
        name: 'ليلى خالد',
        grade: S.current.parentFirstPreparatoryGrade,
      ),
      ParentChildModel(
        name: 'أحمد خالد',
        grade: S.current.parentSecondPreparatoryGrade,
      ),
    ];