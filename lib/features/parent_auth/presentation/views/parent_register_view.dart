import 'package:bnan_app/features/parent_auth/presentation/views/widgets/parent_register_widgets/parent_register_body.dart';
import 'package:flutter/material.dart';

class ParentRegisterView extends StatelessWidget {
  const ParentRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: true,
      body: ParentRegisterBody(),
    );
  }
}
