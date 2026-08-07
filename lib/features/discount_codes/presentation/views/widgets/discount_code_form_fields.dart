import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/features/discount_codes/data/models/discount_code_model.dart';
import 'package:bnan_app/features/discount_codes/presentation/views/widgets/discount_active_switch.dart';
import 'package:bnan_app/features/discount_codes/presentation/views/widgets/discount_date_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class DiscountCodeFormFields extends StatelessWidget {
  const DiscountCodeFormFields({
    super.key,
    required this.code,
    required this.percentage,
    required this.children,
    required this.type,
    required this.active,
    required this.start,
    required this.end,
    required this.onType,
    required this.onActive,
    required this.onStart,
    required this.onEnd,
  });
  final TextEditingController code, percentage, children;
  final DiscountCodeType type;
  final bool active;
  final DateTime? start, end;
  final ValueChanged<DiscountCodeType> onType;
  final ValueChanged<bool> onActive;
  final ValueChanged<DateTime> onStart, onEnd;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      children: [
        CustomTextField(
          label: s.discountCode,
          controller: code,
          isRequired: true,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: s.discountPercentage,
          controller: percentage,
          keyboardType: TextInputType.number,
          isRequired: true,
        ),
        const SizedBox(height: 12),
        CustomDropdown(
          label: s.discountType,
          items: DiscountCodeType.values.map((e) => e.apiValue).toList(),
          itemsLabels: {
            DiscountCodeType.dateRange.apiValue: s.dateRangeDiscount,
            DiscountCodeType.children.apiValue: s.childrenDiscount,
          },
          value: type.apiValue,
          onChanged: (value) => onType(DiscountCodeType.fromValue(value)),
          isRequired: true,
          useDefaultIcon: true,
        ),
        const SizedBox(height: 12),
        if (type == DiscountCodeType.dateRange) ...[
          DiscountDateField(
            label: s.startDate,
            value: start,
            firstDate: DateTime(2000),
            onChanged: onStart,
          ),
          const SizedBox(height: 12),
          DiscountDateField(
            label: s.endDate,
            value: end,
            firstDate: start ?? DateTime(2000),
            onChanged: onEnd,
          ),
        ] else
          CustomTextField(
            label: s.childrenCount,
            controller: children,
            keyboardType: TextInputType.number,
            isRequired: true,
          ),
        DiscountActiveSwitch(
          label: s.isActive,
          value: active,
          onChanged: onActive,
        ),
      ],
    );
  }
}
