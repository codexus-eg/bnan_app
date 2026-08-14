import 'package:bnan_app/core/helper/app_pickers.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/payment_info_step/credit_card_preview.dart';
import 'package:bnan_app/core/shared_widget/schedule_picker_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PaymentInfoStep extends StatefulWidget {
  const PaymentInfoStep({super.key});

  @override
  State<PaymentInfoStep> createState() => _PaymentInfoStepState();
}

class _PaymentInfoStepState extends State<PaymentInfoStep> {
  DateTime? expiryDate;

  Future<void> _pickExpiryDate() async {
    final date = await AppPickers.pickDate(
      context: context,
      initialDate: expiryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2040),
    );

    if (date != null) {
      setState(() => expiryDate = date);
    }
  }

  String _formatExpiryDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString().substring(2);
    return '$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Text(
        //   S.of(context).paymentInfo,
        //   style: StylesManager.styleBold16(context).copyWith(
        //     color: ColorManager.mainColor15,
        //   ),
        // ),
        // const SizedBox(height: 16),
        const CreditCardPreview(),
        const SizedBox(height: 16),
        CustomTextField(label: S.of(context).cardNumber, isRequired: true),
        const SizedBox(height: 16),
        CustomTextField(
          label: S.of(context).cardHolderName,
          isRequired: true,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SchedulePickerField(
                label: S.of(context).expiryDate,
                hintText: 'mm/yy',
                value: expiryDate == null
                    ? null
                    : _formatExpiryDate(expiryDate!),
                icon: ImageManager.teacherAssignmentDateIcon,
                onTap: _pickExpiryDate,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomTextField(
                keyboardType: TextInputType.number,
                label: S.of(context).cvv,
                hintText: '---',
                isRequired: true,
                prefixIcon: const Icon(
                  Icons.check_circle_outline,
                  size: 18,
                  color: ColorManager.greyA8AF,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
