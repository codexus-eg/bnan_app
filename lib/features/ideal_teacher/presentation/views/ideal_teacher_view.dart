import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/ideal_teacher_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class IdealTeacherView extends StatelessWidget {
  const IdealTeacherView({super.key, this.showBackButton = true});

  final bool showBackButton;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppbar(
      headerText: S.of(context).idealTeacher,
      iconNeeded: showBackButton,
    ),
    body: const IdealTeacherBody(),
  );
}
