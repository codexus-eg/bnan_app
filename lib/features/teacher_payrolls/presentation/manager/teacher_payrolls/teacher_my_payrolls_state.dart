import '../../../data/models/payout_profile_model.dart';
import '../../../data/models/teacher_my_payrolls_model.dart';

sealed class TeacherMyPayrollsState {
  const TeacherMyPayrollsState();
}

class TeacherMyPayrollsLoading extends TeacherMyPayrollsState {
  const TeacherMyPayrollsLoading();
}

class TeacherMyPayrollsReady extends TeacherMyPayrollsState {
  const TeacherMyPayrollsReady({
    required this.data,
    required this.profile,
    required this.status,
    this.updating = false,
    this.message,
  });
  final TeacherMyPayrollsModel data;
  final PayoutProfileModel? profile;
  final String? status, message;
  final bool updating;
}

class TeacherMyPayrollsFailure extends TeacherMyPayrollsState {
  const TeacherMyPayrollsFailure(this.message);
  final String message;
}
