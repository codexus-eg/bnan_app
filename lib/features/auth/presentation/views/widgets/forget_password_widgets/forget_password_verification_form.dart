import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/forget_password_widgets/otp_widget.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ForgetPasswordVerificationForm extends StatelessWidget {
  const ForgetPasswordVerificationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OtpWidget(pinController: TextEditingController()),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 28),
          ),
          child: Text(
            S.of(context).resendCode,
            style: StylesManager.styleBold12(
              context,
            ).copyWith(color: ColorManager.secondaryColor),
          ),
        ),
        CustomAppButton(text: S.of(context).verify, onPressed: () {
          MyNavigator.goTo(context, Routes.changePassword);
        }),
      ],
    );
  }
}
