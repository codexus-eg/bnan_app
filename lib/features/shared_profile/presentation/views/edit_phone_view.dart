import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/edit_widgets/edit_phone_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class EditPhoneView extends StatelessWidget {
  const EditPhoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).changePhoneTitle),
      body: EditPhoneBody(),
    );
  }
}
