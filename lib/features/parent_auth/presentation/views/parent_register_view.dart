import 'package:bnan_app/features/parent_auth/presentation/views/widgets/parent_register_widgets/parent_register_body.dart';
import 'package:bnan_app/features/parent_auth/presentation/models/parent_registration_flow_args.dart';
import 'package:flutter/material.dart';

class ParentRegisterView extends StatelessWidget {
  const ParentRegisterView({
    super.key,
    this.args = const ParentRegistrationFlowArgs(),
  });

  final ParentRegistrationFlowArgs args;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ParentRegisterBody(args: args),
    );
  }
}
