import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_session_details_model.dart';

sealed class PayrollSessionsState {
  const PayrollSessionsState();
}

class PayrollSessionsInitial extends PayrollSessionsState {
  const PayrollSessionsInitial();
}

class PayrollSessionsLoading extends PayrollSessionsState {
  const PayrollSessionsLoading();
}

class PayrollSessionsSuccess extends PayrollSessionsState {
  const PayrollSessionsSuccess(this.details);
  final PayrollSessionDetailsModel details;
}

class PayrollSessionsFailure extends PayrollSessionsState {
  const PayrollSessionsFailure(this.message);
  final String message;
}
