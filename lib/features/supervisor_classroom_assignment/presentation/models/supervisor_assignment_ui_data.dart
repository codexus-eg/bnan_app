import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/models/supervisor_assignment_ui_model.dart';
import 'package:bnan_app/generated/l10n.dart';

List<SupervisorAssignmentUiModel> supervisorAssignmentUiData(S s) => [
  SupervisorAssignmentUiModel(
    id: 'supervisor-1',
    name: s.supervisorSaraAhmed,
    assignments: [
      SupervisorClassroomAssignmentUiModel(
        id: 'assignment-1',
        classroomName: s.fourthPrimaryClassroom,
        curriculumName: s.egyptian,
      ),
      SupervisorClassroomAssignmentUiModel(
        id: 'assignment-2',
        classroomName: s.firstPrimaryClassroom,
        curriculumName: s.saudi,
      ),
    ],
  ),
  SupervisorAssignmentUiModel(
    id: 'supervisor-2',
    name: s.supervisorSomaya,
    assignments: [
      SupervisorClassroomAssignmentUiModel(
        id: 'assignment-3',
        classroomName: s.secondSecondaryClassroom,
        curriculumName: s.saudi,
      ),
    ],
  ),
  SupervisorAssignmentUiModel(
    id: 'supervisor-3',
    name: s.supervisorAbdelfattah,
    assignments: [
      SupervisorClassroomAssignmentUiModel(
        id: 'assignment-4',
        classroomName: s.firstPrimaryClassroom,
        curriculumName: s.egyptian,
      ),
    ],
  ),
];

List<String> supervisorClassroomOptions(S s) => [
  s.firstPrimaryClassroom,
  s.fourthPrimaryClassroom,
  s.secondSecondaryClassroom,
];
