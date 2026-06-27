import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/edit_widgets/edit_name_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class EditNameView extends StatelessWidget {
  const EditNameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).changeUsernameTitle),
      body: EditNameBody(),
    );
  }
}
