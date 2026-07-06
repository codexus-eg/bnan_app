import 'package:bnan_app/features/academic_lookups/data/models/academic_classroom_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_curriculum_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_grade_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_lookup_selection.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_subject_model.dart';

const Object _unset = Object();

class AcademicLookupsState {
  const AcademicLookupsState({
    this.curriculums = const [],
    this.grades = const [],
    this.classrooms = const [],
    this.subjects = const [],
    this.selectedCurriculum,
    this.selectedGrade,
    this.selectedClassroom,
    this.selectedSubject,
    this.isLoadingCurriculums = false,
    this.isLoadingGrades = false,
    this.isLoadingClassrooms = false,
    this.isLoadingSubjects = false,
    this.errorMessage,
  });

  final List<AcademicCurriculumModel> curriculums;
  final List<AcademicGradeModel> grades;
  final List<AcademicClassroomModel> classrooms;
  final List<AcademicSubjectModel> subjects;
  final AcademicCurriculumModel? selectedCurriculum;
  final AcademicGradeModel? selectedGrade;
  final AcademicClassroomModel? selectedClassroom;
  final AcademicSubjectModel? selectedSubject;
  final bool isLoadingCurriculums;
  final bool isLoadingGrades;
  final bool isLoadingClassrooms;
  final bool isLoadingSubjects;
  final String? errorMessage;

  AcademicLookupSelection get selection => AcademicLookupSelection(
    curriculumId: selectedCurriculum?.id,
    curriculumName: selectedCurriculum?.name,
    gradeId: selectedGrade?.id,
    gradeName: selectedGrade?.name,
    classroomId: selectedClassroom?.id,
    classroomName: selectedClassroom?.name,
    subjectId: selectedSubject?.id,
    subjectName: selectedSubject?.name,
  );

  AcademicLookupsState copyWith({
    List<AcademicCurriculumModel>? curriculums,
    List<AcademicGradeModel>? grades,
    List<AcademicClassroomModel>? classrooms,
    List<AcademicSubjectModel>? subjects,
    Object? selectedCurriculum = _unset,
    Object? selectedGrade = _unset,
    Object? selectedClassroom = _unset,
    Object? selectedSubject = _unset,
    bool? isLoadingCurriculums,
    bool? isLoadingGrades,
    bool? isLoadingClassrooms,
    bool? isLoadingSubjects,
    Object? errorMessage = _unset,
  }) {
    return AcademicLookupsState(
      curriculums: curriculums ?? this.curriculums,
      grades: grades ?? this.grades,
      classrooms: classrooms ?? this.classrooms,
      subjects: subjects ?? this.subjects,
      selectedCurriculum: identical(selectedCurriculum, _unset)
          ? this.selectedCurriculum
          : selectedCurriculum as AcademicCurriculumModel?,
      selectedGrade: identical(selectedGrade, _unset)
          ? this.selectedGrade
          : selectedGrade as AcademicGradeModel?,
      selectedClassroom: identical(selectedClassroom, _unset)
          ? this.selectedClassroom
          : selectedClassroom as AcademicClassroomModel?,
      selectedSubject: identical(selectedSubject, _unset)
          ? this.selectedSubject
          : selectedSubject as AcademicSubjectModel?,
      isLoadingCurriculums: isLoadingCurriculums ?? this.isLoadingCurriculums,
      isLoadingGrades: isLoadingGrades ?? this.isLoadingGrades,
      isLoadingClassrooms: isLoadingClassrooms ?? this.isLoadingClassrooms,
      isLoadingSubjects: isLoadingSubjects ?? this.isLoadingSubjects,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}
