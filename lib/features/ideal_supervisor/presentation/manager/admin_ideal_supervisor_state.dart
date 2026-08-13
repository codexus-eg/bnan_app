import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/get_supervisors_response_model.dart';

enum AdminIdealSupervisorStatus {
  initial,
  loading,
  loaded,
  submitting,
  success,
  failure,
}

class AdminIdealSupervisorState {
  const AdminIdealSupervisorState({
    this.status = AdminIdealSupervisorStatus.initial,
    this.supervisors = const [],
    this.selectedIds = const {},
    this.message = '',
    this.errorCode,
  });

  final AdminIdealSupervisorStatus status;
  final List<SupervisorModel> supervisors;
  final Set<String> selectedIds;
  final String message;
  final String? errorCode;
  bool get isSubmitting => status == AdminIdealSupervisorStatus.submitting;

  AdminIdealSupervisorState copyWith({
    AdminIdealSupervisorStatus? status,
    List<SupervisorModel>? supervisors,
    Set<String>? selectedIds,
    String? message,
    String? errorCode,
  }) => AdminIdealSupervisorState(
    status: status ?? this.status,
    supervisors: supervisors ?? this.supervisors,
    selectedIds: selectedIds ?? this.selectedIds,
    message: message ?? this.message,
    errorCode: errorCode,
  );
}
