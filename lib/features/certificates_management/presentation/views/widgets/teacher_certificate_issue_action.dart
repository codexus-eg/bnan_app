import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/teacher_certificates_cubit/teacher_certificates_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/dialogs/teacher_certificate_issue_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherCertificateIssueAction extends StatelessWidget {
  const TeacherCertificateIssueAction({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(end: 16, start: 16),
    child: AddNewTopicButton(
      title: S.of(context).issueNewCertificate,
      path: ImageManager.plus,
      onTap: () {
        final cubit = context.read<TeacherCertificatesCubit>();
        showDialog(
          context: context,
          builder: (_) => BlocProvider.value(
            value: cubit,
            child: const TeacherCertificateIssueDialog(),
          ),
        );
      },
    ),
  );
}
