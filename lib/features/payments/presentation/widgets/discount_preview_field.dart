import 'package:bnan_app/features/payments/data/models/discount_preview_request.dart';
import 'package:bnan_app/features/payments/presentation/manager/discount_preview_cubit.dart';
import 'package:bnan_app/features/payments/presentation/manager/discount_preview_state.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/discount_code_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscountPreviewField extends StatelessWidget {
  const DiscountPreviewField({
    super.key,
    required this.request,
    required this.onChanged,
    this.controller,
    this.initialValue,
  });
  final DiscountPreviewRequest? Function() request;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    try {
      context.read<DiscountPreviewCubit>();
    } on ProviderNotFoundException {
      return DiscountCodeField(
        controller: controller,
        initialValue: initialValue,
        onChanged: onChanged,
        applyButtonWidth: 104,
        applyButtonSpacing: 12,
        compactApplyText: true,
      );
    }
    return BlocBuilder<DiscountPreviewCubit, DiscountPreviewState>(
      builder: (context, state) => DiscountCodeField(
        controller: controller,
        initialValue: initialValue,
        isApplying: state.isLoading,
        onChanged: (value) {
          onChanged(value);
          context.read<DiscountPreviewCubit>().invalidate();
        },
        onApply: () => context.read<DiscountPreviewCubit>().apply(request()),
        applyButtonWidth: 104,
        applyButtonSpacing: 12,
        compactApplyText: true,
      ),
    );
  }
}
