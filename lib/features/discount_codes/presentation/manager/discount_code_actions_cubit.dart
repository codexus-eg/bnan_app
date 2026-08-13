import 'package:bnan_app/features/discount_codes/data/models/discount_code_request.dart';
import 'package:bnan_app/features/discount_codes/data/repos/discount_codes_repo.dart';
import 'package:bnan_app/features/discount_codes/presentation/manager/discount_code_actions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscountCodeActionsCubit extends Cubit<DiscountCodeActionsState> {
  DiscountCodeActionsCubit(this.repo)
    : super(const DiscountCodeActionsInitial());
  final DiscountCodesRepo repo;
  bool _busy = false;

  Future<void> save(DiscountCodeRequest request, {String? id}) async {
    if (isClosed || _busy) return;
    _busy = true;
    emit(const DiscountCodeActionLoading());
    try {
      final result = id == null
          ? await repo.create(request)
          : await repo.update(id, request);
      if (isClosed) return;
      result.fold(
        (failure) => emit(DiscountCodeActionFailure(failure.message)),
        (code) {
          final saved = code.code.isEmpty
              ? request.toModel(id: id ?? '')
              : id != null && code.id.isEmpty
              ? code.withId(id)
              : code;
          emit(DiscountCodeSaved(saved));
        },
      );
    } finally {
      _busy = false;
    }
  }

  Future<void> delete(String id) async {
    if (isClosed || _busy) return;
    _busy = true;
    emit(const DiscountCodeActionLoading());
    try {
      final result = await repo.delete(id);
      if (isClosed) return;
      result.fold(
        (failure) => emit(DiscountCodeActionFailure(failure.message)),
        (_) => emit(DiscountCodeDeleted(id)),
      );
    } finally {
      _busy = false;
    }
  }
}
