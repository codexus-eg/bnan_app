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
    if (_busy) return;
    _busy = true;
    emit(const DiscountCodeActionLoading());
    final result = id == null
        ? await repo.create(request)
        : await repo.update(id, request);
    _busy = false;
    result.fold((failure) => emit(DiscountCodeActionFailure(failure.message)), (
      code,
    ) {
      final saved = code.code.isEmpty
          ? request.toModel(id: id ?? '')
          : id != null && code.id.isEmpty
          ? code.withId(id)
          : code;
      emit(DiscountCodeSaved(saved));
    });
  }

  Future<void> delete(String id) async {
    if (_busy) return;
    _busy = true;
    emit(const DiscountCodeActionLoading());
    final result = await repo.delete(id);
    _busy = false;
    result.fold(
      (failure) => emit(DiscountCodeActionFailure(failure.message)),
      (_) => emit(DiscountCodeDeleted(id)),
    );
  }
}
