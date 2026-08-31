import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_model.dart';

sealed class TeacherPayoutProfileState {
  const TeacherPayoutProfileState();
}

class TeacherPayoutProfileInitial extends TeacherPayoutProfileState {
  const TeacherPayoutProfileInitial();
}

class TeacherPayoutProfileLoading extends TeacherPayoutProfileState {
  const TeacherPayoutProfileLoading();
}

class TeacherPayoutProfileEmpty extends TeacherPayoutProfileState {
  const TeacherPayoutProfileEmpty();
}

class TeacherPayoutProfileSaving extends TeacherPayoutProfileState {
  const TeacherPayoutProfileSaving();
}

class TeacherPayoutProfileSuccess extends TeacherPayoutProfileState {
  const TeacherPayoutProfileSuccess(this.profile);
  final PayoutProfileModel profile;
}

class TeacherPayoutProfileFailure extends TeacherPayoutProfileState {
  const TeacherPayoutProfileFailure(this.message);
  final String message;
}
