import 'package:bnan_app/features/discount_codes/data/models/discount_code_model.dart';

sealed class DiscountCodeActionsState {
  const DiscountCodeActionsState();
}

class DiscountCodeActionsInitial extends DiscountCodeActionsState {
  const DiscountCodeActionsInitial();
}

class DiscountCodeActionLoading extends DiscountCodeActionsState {
  const DiscountCodeActionLoading();
}

class DiscountCodeSaved extends DiscountCodeActionsState {
  const DiscountCodeSaved(this.code);
  final DiscountCodeModel code;
}

class DiscountCodeDeleted extends DiscountCodeActionsState {
  const DiscountCodeDeleted(this.id);
  final String id;
}

class DiscountCodeActionFailure extends DiscountCodeActionsState {
  const DiscountCodeActionFailure(this.message);
  final String message;
}
