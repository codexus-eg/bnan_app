import 'package:bnan_app/features/academic_lookups/data/models/academic_curriculum_model.dart';
import 'package:bnan_app/features/parent_home/data/models/parent_child_model.dart';

class ParentAddChildArgs {
  const ParentAddChildArgs({
    required this.curriculumId,
    required this.registrationMode,
    this.curriculumName = '',
  });

  final String curriculumId;
  final String curriculumName;
  final String registrationMode;

  AcademicCurriculumModel get curriculum => AcademicCurriculumModel(
    id: curriculumId,
    name: curriculumName,
    registrationMode: registrationMode,
  );

  static ParentAddChildArgs? fromChildren(List<ParentChildModel> children) {
    ParentAddChildArgs? context;
    for (final child in children) {
      final curriculum = child.curriculum;
      final mode = child.registrationMode ?? curriculum?.registrationMode;
      if (curriculum == null || curriculum.id.isEmpty || mode == null) continue;
      final candidate = ParentAddChildArgs(
        curriculumId: curriculum.id,
        curriculumName: curriculum.name,
        registrationMode: mode.name,
      );
      if (context != null &&
          (context.curriculumId != candidate.curriculumId ||
              context.registrationMode != candidate.registrationMode)) {
        return null;
      }
      context ??= candidate;
    }
    return context;
  }
}
