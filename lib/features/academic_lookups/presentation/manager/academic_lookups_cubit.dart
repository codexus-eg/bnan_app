import 'package:bnan_app/features/academic_lookups/data/models/academic_classroom_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_curriculum_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_grade_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_subject_model.dart';
import 'package:bnan_app/features/academic_lookups/data/repo/academic_lookups_repo.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcademicLookupsCubit extends Cubit<AcademicLookupsState> {
  AcademicLookupsCubit({
    required this.repo,
    this.loadClassroomsOnGrade = true,
    this.loadSubjectsWithoutClassroom = true,
  }) : super(const AcademicLookupsState());

  final AcademicLookupsRepo repo;
  final bool loadClassroomsOnGrade;
  final bool loadSubjectsWithoutClassroom;

  final Map<String, List<AcademicGradeModel>> _gradesByCurriculum = {};
  final Map<String, List<AcademicClassroomModel>> _classroomsByGrade = {};
  final Map<String, List<AcademicSubjectModel>> _subjectsByScope = {};

  Future<void> loadCurriculums() async {
    if (state.curriculums.isNotEmpty || state.isLoadingCurriculums) return;
    emit(state.copyWith(isLoadingCurriculums: true, errorMessage: null));
    final result = await repo.getCurriculums();
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoadingCurriculums: false,
          errorMessage: failure.message,
        ),
      ),
      (items) =>
          emit(state.copyWith(curriculums: items, isLoadingCurriculums: false)),
    );
  }

  Future<void> selectCurriculum(AcademicCurriculumModel? curriculum) async {
    if (state.selectedCurriculum?.id == curriculum?.id) return;
    emit(
      state.copyWith(
        selectedCurriculum: curriculum,
        selectedGrade: null,
        selectedClassroom: null,
        selectedSubject: null,
        grades: const [],
        classrooms: const [],
        subjects: const [],
        errorMessage: null,
      ),
    );
    if (curriculum == null) return;
    await _loadGrades(curriculum.id);
  }

  Future<void> selectGrade(AcademicGradeModel? grade) async {
    if (state.selectedGrade?.id == grade?.id) return;
    emit(
      state.copyWith(
        selectedGrade: grade,
        selectedClassroom: null,
        selectedSubject: null,
        classrooms: const [],
        subjects: const [],
        errorMessage: null,
      ),
    );
    final curriculum = state.selectedCurriculum;
    if (curriculum == null || grade == null) return;
    if (loadClassroomsOnGrade) await _loadClassrooms(curriculum.id, grade.id);
    if (!loadClassroomsOnGrade && loadSubjectsWithoutClassroom) {
      await _loadSubjects(curriculumId: curriculum.id, gradeId: grade.id);
    }
  }

  Future<void> selectClassroom(AcademicClassroomModel? classroom) async {
    if (state.selectedClassroom?.id == classroom?.id) return;
    emit(
      state.copyWith(
        selectedClassroom: classroom,
        selectedSubject: null,
        subjects: const [],
        errorMessage: null,
      ),
    );
    final curriculum = state.selectedCurriculum;
    final grade = state.selectedGrade;
    if (curriculum == null || grade == null || classroom == null) return;
    await _loadSubjects(
      curriculumId: curriculum.id,
      gradeId: grade.id,
      classroomId: classroom.id,
    );
  }

  void selectSubject(AcademicSubjectModel? subject) {
    if (state.selectedSubject?.id == subject?.id) return;
    emit(state.copyWith(selectedSubject: subject, errorMessage: null));
  }

  Future<void> _loadGrades(String curriculumId) async {
    final cached = _gradesByCurriculum[curriculumId];
    if (cached != null) return emit(state.copyWith(grades: cached));
    emit(state.copyWith(isLoadingGrades: true));
    final result = await repo.getGradesByCurriculum(curriculumId);
    if (state.selectedCurriculum?.id != curriculumId) return;
    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingGrades: false, errorMessage: failure.message),
      ),
      (items) {
        _gradesByCurriculum[curriculumId] = items;
        emit(state.copyWith(grades: items, isLoadingGrades: false));
      },
    );
  }

  Future<void> _loadClassrooms(String curriculumId, String gradeId) async {
    final cacheKey = '$curriculumId:$gradeId';
    final cached = _classroomsByGrade[cacheKey];
    if (cached != null) return emit(state.copyWith(classrooms: cached));
    emit(state.copyWith(isLoadingClassrooms: true));
    final result = await repo.getClassroomsByGrade(
      curriculumId: curriculumId,
      gradeId: gradeId,
    );
    if (state.selectedGrade?.id != gradeId) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoadingClassrooms: false,
          errorMessage: failure.message,
        ),
      ),
      (items) {
        _classroomsByGrade[cacheKey] = items;
        emit(state.copyWith(classrooms: items, isLoadingClassrooms: false));
      },
    );
  }

  Future<void> _loadSubjects({
    required String curriculumId,
    required String gradeId,
    String? classroomId,
  }) async {
    final cacheKey = '$curriculumId:$gradeId:${classroomId ?? ''}';
    final cached = _subjectsByScope[cacheKey];
    if (cached != null) return emit(state.copyWith(subjects: cached));
    emit(state.copyWith(isLoadingSubjects: true));
    final result = await repo.getSubjects(
      curriculumId: curriculumId,
      gradeId: gradeId,
      classroomId: classroomId,
    );
    if (state.selectedGrade?.id != gradeId) return;
    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingSubjects: false, errorMessage: failure.message),
      ),
      (items) {
        _subjectsByScope[cacheKey] = items;
        emit(state.copyWith(subjects: items, isLoadingSubjects: false));
      },
    );
  }
}
