import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class RegistrationSuccess extends StatelessWidget {
  const RegistrationSuccess({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            S.of(context).registrationRequestSuccessMessage,
            textAlign: TextAlign.center,
            style: StylesManager.styleBold16(context),
          ),
          const SizedBox(height: 24),
          CustomAppButton(
            text: S.of(context).backToLogin,
            onPressed: () => MyNavigator.goToOffAll(context, Routes.logIn),
          ),
        ],
      ),
    ),
  );
}
