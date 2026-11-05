import 'package:bnan_app/features/academic_lookups/data/models/academic_curriculum_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_grade_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_subject_model.dart';
import 'package:bnan_app/features/academic_lookups/data/repo/academic_lookups_repo.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/shared_classroom_form_state.dart';

Future<SharedClassroomFormState> initSharedClassroomState(
  AcademicLookupsRepo repo,
  List<AcademicCurriculumModel> curriculums,
) async {
  final eg = curriculums.where((c) {
    final n = c.name.toLowerCase();
    return n.contains('مصر') || n.contains('egypt');
  }).firstOrNull;
  if (eg == null) return const SharedClassroomFormState();
  final gradesRes = await repo.getGrades(curriculumId: eg.id);
  final grades = gradesRes.fold((_) => <AcademicGradeModel>[], (l) => l);
  return SharedClassroomFormState(curriculumId: eg.id, grades: grades);
}

Future<SharedClassroomFormState> updateSharedGradeSubjects(
  AcademicLookupsRepo repo,
  SharedClassroomFormState current, {
  String? grade1Id,
  String? grade2Id,
}) async {
  final currId = current.curriculumId;
  final g1 = grade1Id ?? current.grade1Id;
  final g2 = grade2Id ?? current.grade2Id;
  if (currId == null) return current.copyWith(grade1Id: g1, grade2Id: g2);

  final subs1 = g1 != null ? await repo.getSubjects(curriculumId: currId, gradeId: g1) : null;
  final subs2 = g2 != null ? await repo.getSubjects(curriculumId: currId, gradeId: g2) : null;

  final sA = subs1?.fold((_) => <AcademicSubjectModel>[], (l) => l) ?? current.subjectsA;
  final sB = subs2?.fold((_) => <AcademicSubjectModel>[], (l) => l) ?? current.subjectsB;

  final updated = current.copyWith(grade1Id: g1, grade2Id: g2, subjectsA: sA, subjectsB: sB, loadingSubjects: false);
  return updated.copyWith(selectedSubjectIds: updated.unionSubjects.map((s) => s.id).toSet());
}
