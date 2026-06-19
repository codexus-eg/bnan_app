import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/curricula_widgets/curricula_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CurriculaView extends StatelessWidget {
  const CurriculaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).curricula),
      body: CurriculaBody(),
    );
  }
}
