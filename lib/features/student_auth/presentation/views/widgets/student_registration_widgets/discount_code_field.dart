import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class DiscountCodeField extends StatelessWidget {
  const DiscountCodeField({super.key, this.controller, this.onChanged});

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final effectiveController =
        controller ??
        (onChanged == null
            ? RegisterCubit.get(context).discountCodeController
            : null);
    return CustomTextField(
      label: S.of(context).optionalDiscountCode,
      hintText: S.of(context).enterDiscountCode,
      controller: effectiveController,
      onChanged: onChanged,
    );
  }
}
