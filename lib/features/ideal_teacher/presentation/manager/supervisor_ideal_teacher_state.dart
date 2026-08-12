import 'package:bnan_app/features/ideal_teacher/data/models/supervisor_teacher_model.dart';

enum SupervisorIdealTeacherStatus {
  initial,
  loadingTeachers,
  teachersLoaded,
  submitting,
  success,
  failure,
}

class SupervisorIdealTeacherState {
  const SupervisorIdealTeacherState({
    this.status = SupervisorIdealTeacherStatus.initial,
    this.teachers = const [],
    this.selectedTeacherIds = const {},
    this.message = '',
  });

  final SupervisorIdealTeacherStatus status;
  final List<SupervisorTeacherModel> teachers;
  final Set<String> selectedTeacherIds;
  final String message;
  bool get isSubmitting => status == SupervisorIdealTeacherStatus.submitting;

  SupervisorIdealTeacherState copyWith({
    SupervisorIdealTeacherStatus? status,
    List<SupervisorTeacherModel>? teachers,
    Set<String>? selectedTeacherIds,
    String? message,
  }) => SupervisorIdealTeacherState(
    status: status ?? this.status,
    teachers: teachers ?? this.teachers,
    selectedTeacherIds: selectedTeacherIds ?? this.selectedTeacherIds,
    message: message ?? this.message,
  );
}
