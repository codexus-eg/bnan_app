import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class DiscountCodeField extends StatelessWidget {
  const DiscountCodeField({
    super.key,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onApply,
    this.isApplying = false,
    this.applyButtonWidth,
    this.applyButtonSpacing,
    this.compactApplyText = false,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onApply;
  final bool isApplying;
  final double? applyButtonWidth;
  final double? applyButtonSpacing;
  final bool compactApplyText;

  @override
  Widget build(BuildContext context) {
    final effectiveController =
        controller ??
        (onChanged == null
            ? RegisterCubit.get(context).discountCodeController
            : null);
    final field = CustomTextField(
      label: S.of(context).optionalDiscountCode,
      hintText: S.of(context).enterDiscountCode,
      controller: effectiveController,
      initialValue: initialValue,
      onChanged: onChanged,
    );
    if (onApply == null) return field;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: field),
        SizedBox(width: applyButtonSpacing ?? 8),
        SizedBox(
          width: applyButtonWidth ?? 88,
          child: CustomAppButton(
            text: S.of(context).applyDiscountCode,
            isLoading: isApplying,
            height: 48,
            style: compactApplyText ? StylesManager.styleBold14(context).copyWith(
              color: ColorManager.white
            ) : null,
            singleLine: compactApplyText,
            onPressed: onApply,
          ),
        ),
      ],
    );
  }
}
