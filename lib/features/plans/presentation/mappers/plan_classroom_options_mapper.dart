import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_model.dart';
import 'package:bnan_app/features/student_groups/data/models/student_enrollment_model.dart';
import 'package:bnan_app/features/supervisor_management/data/models/supervisor_classroom_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_class_room_model.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';

List<PlanClassroomOption> mapTeacherClassroomsToPlanOptions(
  List<TeacherClassroomModel> classrooms,
) => _unique(
  classrooms.map(
    (item) => PlanClassroomOption(
      id: item.id,
      name: item.name,
      registrationMode: item.registrationMode,
    ),
  ),
);

List<PlanClassroomOption> mapStudentEnrollmentsToPlanOptions(
  List<StudentEnrollmentModel> enrollments,
) => _unique(
  enrollments
      .where((item) => item.isApproved)
      .map(
        (item) => PlanClassroomOption(
          id: item.classroom.id,
          name: item.classroom.name,
        ),
      ),
);

List<PlanClassroomOption> mapGulfScheduleToPlanOptions(
  List<GulfClassroom> classrooms,
) => _unique(
  classrooms
      .where((item) => item.subject != null && !item.hasSubjectConflict)
      .map((item) => PlanClassroomOption(id: item.id, name: item.name)),
);

List<PlanClassroomOption> mapSupervisorClassroomsToPlanOptions(
  List<SupervisorClassroomModel> classrooms,
) => _unique(
  classrooms.map((item) => PlanClassroomOption(id: item.id, name: item.name)),
);

List<PlanClassroomOption> mapAdminClassroomsToPlanOptions(
  List<ClassroomModel> classrooms,
) => _unique(
  classrooms.map((item) => PlanClassroomOption(id: item.id, name: item.name)),
);

List<PlanClassroomOption> _unique(Iterable<PlanClassroomOption> options) {
  final uniqueById = <String, PlanClassroomOption>{};
  for (final option in options) {
    final id = option.id.trim();
    if (id.isNotEmpty) {
      uniqueById[id] = PlanClassroomOption(
        id: id,
        name: option.name.trim(),
        registrationMode: option.registrationMode,
      );
    }
  }
  return uniqueById.values.toList(growable: false);
}
