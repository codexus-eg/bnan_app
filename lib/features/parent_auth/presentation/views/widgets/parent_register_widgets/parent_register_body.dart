import 'package:bnan_app/core/shared_widget/custom_registration_widgets/registration_header.dart';
import 'package:bnan_app/features/parent_auth/presentation/views/widgets/parent_register_widgets/parent_register_form.dart';
import 'package:bnan_app/features/parent_auth/presentation/models/parent_registration_flow_args.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ParentRegisterBody extends StatelessWidget {
  const ParentRegisterBody({super.key, required this.args});

  final ParentRegistrationFlowArgs args;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsetsDirectional.fromSTEB(16, 36, 16, 24),
        child: Column(
          children: [
            RegistrationHeader(
              title: S.of(context).parentRegistrationForm,
              subtitle: S.of(context).pleaseFillRequiredInfo,
            ),
            const SizedBox(height: 28),
            ParentRegisterForm(args: args),
          ],
        ),
      ),
    );
  }
}
