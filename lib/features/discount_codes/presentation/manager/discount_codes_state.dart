import 'package:bnan_app/features/discount_codes/data/models/discount_code_model.dart';

sealed class DiscountCodesState {
  const DiscountCodesState();
}

class DiscountCodesInitial extends DiscountCodesState {
  const DiscountCodesInitial();
}

class DiscountCodesLoading extends DiscountCodesState {
  const DiscountCodesLoading();
}

class DiscountCodesSuccess extends DiscountCodesState {
  const DiscountCodesSuccess(this.codes);
  final List<DiscountCodeModel> codes;
}

class DiscountCodesFailure extends DiscountCodesState {
  const DiscountCodesFailure(this.message);
  final String message;
}
