import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/add_classroom_subject/presentation/views/widgets/add_classroom_subject_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AddClassroomSubjectView extends StatelessWidget {
  const AddClassroomSubjectView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppbar(headerText: S.of(context).addSubjectToClassroom),
    body: const AddClassroomSubjectBody(),
  );
}
