import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/student_registration_widgets/payment_info_step/credit_card_details_row.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/student_registration_widgets/payment_info_step/credit_card_header.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/student_registration_widgets/payment_info_step/credit_card_number_row.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/student_registration_widgets/payment_info_step/master_card_logo.dart';
import 'package:flutter/material.dart';

class CreditCardPreview extends StatelessWidget {
  const CreditCardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.only(
        start: 13,
        end: 20,
        top: 13,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ColorManager.mainColor0A, ColorManager.purple703C],
        ),
      ),
      child: const Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CreditCardHeader(),
            SizedBox(height: 34),
            CreditCardNumberRow(),
            SizedBox(height: 16),
            CreditCardDetailsRow(),
            SizedBox(height: 16),
            _CardFooter(),
          ],
        ),
      ),
    );
  }
}

class _CardFooter extends StatelessWidget {
  const _CardFooter();

  @override
  Widget build(BuildContext context) {
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Okechukwu ozioma',
          style: StylesManager.styleBold16(context).copyWith(
            color: ColorManager.white
          )
        ),
        MasterCardLogo(),
      ],
    );
  }
}