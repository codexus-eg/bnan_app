import 'package:bnan_app/features/payments/data/models/discount_preview_request.dart';
import 'package:bnan_app/features/payments/data/repo/discount_preview_repo.dart';
import 'package:bnan_app/features/payments/presentation/manager/discount_preview_state.dart';
import 'package:bnan_app/features/payments/presentation/policies/discount_preview_error_mapper.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:bnan_app/features/student_auth/data/debug/gulf_registration_diagnostics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscountPreviewCubit extends Cubit<DiscountPreviewState> {
  DiscountPreviewCubit(this.repo) : super(const DiscountPreviewState());
  final DiscountPreviewRepo repo;
  int _generation = 0;

  void invalidate() {
    _generation++;
    emit(const DiscountPreviewState());
  }

  Future<void> apply(DiscountPreviewRequest? request) async {
    if (request == null || request.discountCode.isEmpty) {
      emit(
        DiscountPreviewState(
          error: S.current.discountCodeRequired,
          fingerprint: request?.fingerprint,
        ),
      );
      return;
    }
    final generation = ++_generation;
    GulfRegistrationDiagnostics.flow('discount preview requested');
    GulfRegistrationDiagnostics.discountPreviewPayload(request.toJson());
    emit(
      DiscountPreviewState(isLoading: true, fingerprint: request.fingerprint),
    );
    final result = await repo.preview(request);
    if (isClosed || generation != _generation) return;
    result.fold(
      (failure) {
        GulfRegistrationDiagnostics.flow(
          'discount preview failure code='
          '${failure.code ?? failure.statusCode ?? 'unknown'}',
        );
        emit(
          DiscountPreviewState(
            error: mapDiscountPreviewFailure(failure),
            fingerprint: request.fingerprint,
          ),
        );
      },
      (summary) {
        GulfRegistrationDiagnostics.flow(
          'discount preview success: original=${summary.originalAmount}; '
          'discount=${summary.discountAmount}; final=${summary.finalAmount}',
        );
        emit(
          DiscountPreviewState(
            summary: summary,
            fingerprint: request.fingerprint,
          ),
        );
      },
    );
  }
}
