import 'package:bnan_app/features/academic_lookups/data/models/academic_classroom_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_curriculum_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_grade_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_subject_model.dart';
import 'package:bnan_app/features/academic_lookups/data/repo/academic_lookups_repo.dart';
import 'package:bnan_app/features/add_classroom_subject/presentation/manager/add_classroom_subject_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddClassroomSubjectCubit extends Cubit<AddClassroomSubjectState> {
  AddClassroomSubjectCubit(this.repo) : super(const AddClassroomSubjectState());

  final AcademicLookupsRepo repo;

  Future<void> load() async {
    if (state.loadingCurriculums || state.curriculums.isNotEmpty) return;
    emit(state.copyWith(loadingCurriculums: true, lookupError: null));
    final result = await repo.getCurriculums();
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(loadingCurriculums: false, lookupError: failure.message),
      ),
      (items) =>
          emit(state.copyWith(curriculums: items, loadingCurriculums: false)),
    );
  }

  Future<void> selectCurriculum(AcademicCurriculumModel? item) async {
    if (isClosed || state.submitting) return;
    emit(
      AddClassroomSubjectState(
        curriculums: state.curriculums,
        selectedCurriculum: item,
      ),
    );
    if (item == null) return;
    emit(state.copyWith(loadingGrades: true));
    final result = await repo.getGrades(curriculumId: item.id);
    if (isClosed || state.selectedCurriculum?.id != item.id) return;
    result.fold(
      (failure) => emit(
        state.copyWith(loadingGrades: false, lookupError: failure.message),
      ),
      (items) => emit(state.copyWith(grades: items, loadingGrades: false)),
    );
  }

  Future<void> selectGrade(AcademicGradeModel? item) async {
    if (isClosed || state.submitting) return;
    emit(
      state.copyWith(
        selectedGrade: item,
        selectedClassroom: null,
        selectedSubject: null,
        classrooms: const [],
        gradeSubjects: const [],
        classroomSubjects: const [],
        lookupError: null,
      ),
    );
    final curriculum = state.selectedCurriculum;
    if (item == null || curriculum == null) return;
    await Future.wait([
      _loadClassrooms(curriculum.id, item.id),
      _loadGradeSubjects(curriculum.id, item.id),
    ]);
  }

  Future<void> selectClassroom(AcademicClassroomModel? item) async {
    if (isClosed || state.submitting) return;
    emit(
      state.copyWith(
        selectedClassroom: item,
        selectedSubject: null,
        classroomSubjects: const [],
        lookupError: null,
      ),
    );
    if (item != null) await _loadClassroomSubjects(item.id);
  }

  void selectSubject(AcademicSubjectModel? item) {
    if (!isClosed && !state.submitting) {
      emit(state.copyWith(selectedSubject: item, submitError: null));
    }
  }

  Future<void> _loadClassrooms(String curriculumId, String gradeId) async {
    emit(state.copyWith(loadingClassrooms: true));
    final result = await repo.getClassroomsByGrade(
      curriculumId: curriculumId,
      gradeId: gradeId,
    );
    if (isClosed || state.selectedGrade?.id != gradeId) return;
    result.fold(
      (failure) => emit(
        state.copyWith(loadingClassrooms: false, lookupError: failure.message),
      ),
      (items) =>
          emit(state.copyWith(classrooms: items, loadingClassrooms: false)),
    );
  }

  Future<void> _loadGradeSubjects(String curriculumId, String gradeId) async {
    emit(state.copyWith(loadingGradeSubjects: true));
    final result = await repo.getSubjects(
      curriculumId: curriculumId,
      gradeId: gradeId,
    );
    if (isClosed || state.selectedGrade?.id != gradeId) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          loadingGradeSubjects: false,
          lookupError: failure.message,
        ),
      ),
      (items) => emit(
        state.copyWith(gradeSubjects: items, loadingGradeSubjects: false),
      ),
    );
  }

  Future<void> _loadClassroomSubjects(String classroomId) async {
    final curriculumId = state.selectedCurriculum?.id;
    final gradeId = state.selectedGrade?.id;
    if (curriculumId == null || gradeId == null) return;
    emit(state.copyWith(loadingClassroomSubjects: true));
    final result = await repo.getSubjects(
      curriculumId: curriculumId,
      gradeId: gradeId,
      classroomId: classroomId,
    );
    if (isClosed || state.selectedClassroom?.id != classroomId) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          loadingClassroomSubjects: false,
          lookupError: failure.message,
        ),
      ),
      (items) {
        final assignedIds = items.map((item) => item.id).toSet();
        final selected = assignedIds.contains(state.selectedSubject?.id)
            ? null
            : state.selectedSubject;
        emit(
          state.copyWith(
            classroomSubjects: items,
            selectedSubject: selected,
            loadingClassroomSubjects: false,
          ),
        );
      },
    );
  }

  Future<void> submit() async {
    final classroom = state.selectedClassroom;
    final subject = state.selectedSubject;
    if (!state.canSubmit || classroom == null || subject == null) return;
    emit(state.copyWith(submitting: true, submitted: false, submitError: null));
    final result = await repo.addClassroomSubject(
      classroomId: classroom.id,
      subjectId: subject.id,
    );
    if (isClosed) return;
    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            submitting: false,
            submitError: failure.message,
            eventId: state.eventId + 1,
          ),
        );
        await _loadClassroomSubjects(classroom.id);
      },
      (_) async {
        emit(
          state.copyWith(
            classroomSubjects: [...state.classroomSubjects, subject],
            selectedSubject: null,
            submitting: false,
            submitted: true,
            eventId: state.eventId + 1,
          ),
        );
        await _loadClassroomSubjects(classroom.id);
      },
    );
  }
}
