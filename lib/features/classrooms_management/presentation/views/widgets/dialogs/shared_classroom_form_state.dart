import 'package:bnan_app/features/academic_lookups/data/models/academic_grade_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_subject_model.dart';

class SharedClassroomFormState {
  const SharedClassroomFormState({
    this.curriculumId,
    this.grades = const [],
    this.grade1Id,
    this.grade2Id,
    this.primaryTargetIndex = 0,
    this.subjectsA = const [],
    this.subjectsB = const [],
    this.selectedSubjectIds = const {},
    this.loadingSubjects = false,
  });

  final String? curriculumId;
  final List<AcademicGradeModel> grades;
  final String? grade1Id, grade2Id;
  final int primaryTargetIndex;
  final List<AcademicSubjectModel> subjectsA, subjectsB;
  final Set<String> selectedSubjectIds;
  final bool loadingSubjects;

  List<AcademicSubjectModel> get unionSubjects {
    final Map<String, AcademicSubjectModel> map = {};
    for (final s in [...subjectsA, ...subjectsB]) {
      final key = s.name.trim().toLowerCase();
      if (!map.containsKey(key)) map[key] = s;
    }
    return map.values.toList();
  }

  String? get primaryGradeId => primaryTargetIndex == 0 ? grade1Id : grade2Id;

  SharedClassroomFormState copyWith({
    String? curriculumId,
    List<AcademicGradeModel>? grades,
    String? grade1Id,
    String? grade2Id,
    int? primaryTargetIndex,
    List<AcademicSubjectModel>? subjectsA,
    List<AcademicSubjectModel>? subjectsB,
    Set<String>? selectedSubjectIds,
    bool? loadingSubjects,
  }) => SharedClassroomFormState(
    curriculumId: curriculumId ?? this.curriculumId,
    grades: grades ?? this.grades,
    grade1Id: grade1Id ?? this.grade1Id,
    grade2Id: grade2Id ?? this.grade2Id,
    primaryTargetIndex: primaryTargetIndex ?? this.primaryTargetIndex,
    subjectsA: subjectsA ?? this.subjectsA,
    subjectsB: subjectsB ?? this.subjectsB,
    selectedSubjectIds: selectedSubjectIds ?? this.selectedSubjectIds,
    loadingSubjects: loadingSubjects ?? this.loadingSubjects,
  );
}
