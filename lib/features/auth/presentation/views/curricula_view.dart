import 'package:bnan_app/features/auth/presentation/views/widgets/curricula_widgets/curricula_body.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/shared_widgets/custom_auth_appbar.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CurriculaView extends StatelessWidget {
  const CurriculaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAuthAppbar(title: S.of(context).curricula),
      body: CurriculaBody(),
    );
  }
}
