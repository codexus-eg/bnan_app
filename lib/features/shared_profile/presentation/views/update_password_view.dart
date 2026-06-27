import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/edit_widgets/update_password_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class UpdatePasswordView extends StatelessWidget {
  const UpdatePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).changePasswordTitle),
      body: UpdatePasswordBody(),
    );
  }
}
