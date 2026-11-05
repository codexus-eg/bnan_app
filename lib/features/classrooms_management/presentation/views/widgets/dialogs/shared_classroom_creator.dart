import 'package:bnan_app/features/classrooms_management/data/models/classroom_request_model.dart';
import 'package:bnan_app/features/classrooms_management/data/models/shared_academic_target.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/shared_classroom_form_state.dart';
import 'package:bnan_app/generated/l10n.dart';

ClassroomRequestModel? buildSharedClassroomRequest({
  required String name,
  required SharedClassroomFormState state,
  required String? supervisorId,
  required void Function(String) onError,
}) {
  if (state.curriculumId == null || state.grade1Id == null || state.grade2Id == null) {
    onError(S.current.sharedClassroomTargetsRequired);
    return null;
  }
  if (state.grade1Id == state.grade2Id) {
    onError(S.current.sharedClassroomRequiresTwoTargets);
    return null;
  }
  final primaryGradeId = state.primaryGradeId;
  if (primaryGradeId == null || (primaryGradeId != state.grade1Id && primaryGradeId != state.grade2Id)) {
    onError(S.current.sharedClassroomPrimaryTargetRequired);
    return null;
  }
  if (supervisorId == null) {
    onError(S.current.fillAllRequiredFields);
    return null;
  }
  return ClassroomRequestModel(
    name: name,
    curriculumId: state.curriculumId,
    gradeId: primaryGradeId,
    supervisorId: supervisorId,
    classroomKind: 'shared',
    sharedAcademicTargets: [
      SharedAcademicTarget(curriculum: state.curriculumId!, grade: state.grade1Id!),
      SharedAcademicTarget(curriculum: state.curriculumId!, grade: state.grade2Id!),
    ],
    subjects: state.selectedSubjectIds.toList(),
  );
}
