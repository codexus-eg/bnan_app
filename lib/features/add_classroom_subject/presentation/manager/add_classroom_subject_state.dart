import 'package:bnan_app/features/academic_lookups/data/models/academic_classroom_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_curriculum_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_grade_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_subject_model.dart';

class AddClassroomSubjectState {
  const AddClassroomSubjectState({
    this.curriculums = const [],
    this.grades = const [],
    this.classrooms = const [],
    this.gradeSubjects = const [],
    this.classroomSubjects = const [],
    this.eligibleSubjects = const [],
    this.selectedCurriculum,
    this.selectedGrade,
    this.selectedClassroom,
    this.selectedSubject,
    this.loadingCurriculums = false,
    this.loadingGrades = false,
    this.loadingClassrooms = false,
    this.loadingGradeSubjects = false,
    this.loadingClassroomSubjects = false,
    this.submitting = false,
    this.submitted = false,
    this.lookupError,
    this.submitError,
    this.eventId = 0,
  });

  final List<AcademicCurriculumModel> curriculums;
  final List<AcademicGradeModel> grades;
  final List<AcademicClassroomModel> classrooms;
  final List<AcademicSubjectModel> gradeSubjects, classroomSubjects, eligibleSubjects;
  final AcademicCurriculumModel? selectedCurriculum;
  final AcademicGradeModel? selectedGrade;
  final AcademicClassroomModel? selectedClassroom;
  final AcademicSubjectModel? selectedSubject;
  final bool loadingCurriculums, loadingGrades, loadingClassrooms;
  final bool loadingGradeSubjects, loadingClassroomSubjects, submitting;
  final bool submitted;
  final String? lookupError, submitError;
  final int eventId;

  List<AcademicSubjectModel> get availableSubjects {
    if (eligibleSubjects.isNotEmpty) {
      return eligibleSubjects;
    }
    final assigned = classroomSubjects.map((item) => item.id).toSet();
    return gradeSubjects
        .where((item) => !assigned.contains(item.id))
        .toList(growable: false);
  }

  bool get canSubmit =>
      selectedClassroom != null && selectedSubject != null && !submitting;

  AddClassroomSubjectState copyWith({
    List<AcademicCurriculumModel>? curriculums,
    List<AcademicGradeModel>? grades,
    List<AcademicClassroomModel>? classrooms,
    List<AcademicSubjectModel>? gradeSubjects,
    List<AcademicSubjectModel>? classroomSubjects,
    List<AcademicSubjectModel>? eligibleSubjects,
    Object? selectedCurriculum = _unset,
    Object? selectedGrade = _unset,
    Object? selectedClassroom = _unset,
    Object? selectedSubject = _unset,
    bool? loadingCurriculums,
    bool? loadingGrades,
    bool? loadingClassrooms,
    bool? loadingGradeSubjects,
    bool? loadingClassroomSubjects,
    bool? submitting,
    bool? submitted,
    Object? lookupError = _unset,
    Object? submitError = _unset,
    int? eventId,
  }) => AddClassroomSubjectState(
    curriculums: curriculums ?? this.curriculums,
    grades: grades ?? this.grades,
    classrooms: classrooms ?? this.classrooms,
    gradeSubjects: gradeSubjects ?? this.gradeSubjects,
    classroomSubjects: classroomSubjects ?? this.classroomSubjects,
    eligibleSubjects: eligibleSubjects ?? this.eligibleSubjects,
    selectedCurriculum: selectedCurriculum == _unset
        ? this.selectedCurriculum
        : selectedCurriculum as AcademicCurriculumModel?,
    selectedGrade: selectedGrade == _unset
        ? this.selectedGrade
        : selectedGrade as AcademicGradeModel?,
    selectedClassroom: selectedClassroom == _unset
        ? this.selectedClassroom
        : selectedClassroom as AcademicClassroomModel?,
    selectedSubject: selectedSubject == _unset
        ? this.selectedSubject
        : selectedSubject as AcademicSubjectModel?,
    loadingCurriculums: loadingCurriculums ?? this.loadingCurriculums,
    loadingGrades: loadingGrades ?? this.loadingGrades,
    loadingClassrooms: loadingClassrooms ?? this.loadingClassrooms,
    loadingGradeSubjects: loadingGradeSubjects ?? this.loadingGradeSubjects,
    loadingClassroomSubjects:
        loadingClassroomSubjects ?? this.loadingClassroomSubjects,
    submitting: submitting ?? this.submitting,
    submitted: submitted ?? this.submitted,
    lookupError: lookupError == _unset
        ? this.lookupError
        : lookupError as String?,
    submitError: submitError == _unset
        ? this.submitError
        : submitError as String?,
    eventId: eventId ?? this.eventId,
  );
}

const _unset = Object();
