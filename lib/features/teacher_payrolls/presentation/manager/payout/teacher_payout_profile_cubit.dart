import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/repo/teacher_payroll_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'teacher_payout_profile_state.dart';

class TeacherPayoutProfileCubit extends Cubit<TeacherPayoutProfileState> {
  TeacherPayoutProfileCubit(this.repo)
    : super(const TeacherPayoutProfileInitial());
  final TeacherPayrollRepo repo;
  bool _loading = false;
  bool _saving = false;

  Future<void> loadMine() async {
    if (isClosed || _loading || _saving) return;
    _loading = true;
    emit(const TeacherPayoutProfileLoading());
    final result = await repo.getMyPayoutProfile();
    _loading = false;
    if (isClosed) return;
    result.fold(
      (failure) => emit(TeacherPayoutProfileFailure(_message(failure))),
      (profile) => emit(
        profile == null
            ? const TeacherPayoutProfileEmpty()
            : TeacherPayoutProfileSuccess(profile),
      ),
    );
  }

  Future<void> saveMine(PayoutProfileRequest request) =>
      _save(() => repo.saveMyPayoutProfile(request), request);

  Future<void> save(String teacherId, PayoutProfileRequest request) async {
    await _save(() => repo.updatePayoutProfile(teacherId, request), request);
  }

  Future<void> _save(
    Future<Either<Failure, PayoutProfileModel>> Function() action,
    PayoutProfileRequest request,
  ) async {
    if (isClosed || _saving || !request.isValid) return;
    _saving = true;
    emit(const TeacherPayoutProfileSaving());
    final result = await action();
    _saving = false;
    if (isClosed) return;
    result.fold(
      (f) {
        if (isClosed) return;
        emit(TeacherPayoutProfileFailure(_message(f)));
      },
      (p) {
        if (isClosed) return;
        emit(TeacherPayoutProfileSuccess(p));
      },
    );
  }

  String _message(Failure failure) {
    if (!failure.responseReceived) return S.current.payoutNetworkError;
    if (failure.statusCode == 401) return S.current.payoutUnauthorized;
    if (failure.statusCode == 403) return S.current.payoutForbidden;
    return switch (failure.code) {
      'INVALID_PAYOUT_METHOD' => S.current.payoutInvalidMethod,
      'PAYOUT_ACCOUNT_HOLDER_REQUIRED' => S.current.payoutHolderRequired,
      'PAYOUT_WALLET_DATA_REQUIRED' => S.current.payoutWalletRequired,
      'PAYOUT_BANK_DATA_REQUIRED' => S.current.payoutBankRequired,
      'PAYOUT_INSTAPAY_ADDRESS_REQUIRED' => S.current.payoutInstapayRequired,
      _ => failure.message,
    };
  }
}
