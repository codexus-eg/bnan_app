import 'package:bnan_app/features/discount_codes/data/models/discount_code_model.dart';
import 'package:bnan_app/features/discount_codes/data/repos/discount_codes_repo.dart';
import 'package:bnan_app/features/discount_codes/presentation/manager/discount_codes_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscountCodesCubit extends Cubit<DiscountCodesState> {
  DiscountCodesCubit(this.repo) : super(const DiscountCodesInitial());
  final DiscountCodesRepo repo;
  final List<DiscountCodeModel> _codes = [];
  bool _loading = false;

  Future<void> load() async {
    if (_loading) return;
    _loading = true;
    emit(const DiscountCodesLoading());
    final result = await repo.getAll();
    _loading = false;
    result.fold((failure) => emit(DiscountCodesFailure(failure.message)), (
      codes,
    ) {
      _codes
        ..clear()
        ..addAll(codes);
      emit(DiscountCodesSuccess(List.unmodifiable(_codes)));
    });
  }

  void upsert(DiscountCodeModel code) {
    final index = _codes.indexWhere((item) => item.id == code.id);
    index < 0 ? _codes.insert(0, code) : _codes[index] = code;
    emit(DiscountCodesSuccess(List.unmodifiable(_codes)));
  }

  void remove(String id) {
    _codes.removeWhere((item) => item.id == id);
    emit(DiscountCodesSuccess(List.unmodifiable(_codes)));
  }
}
