import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/teacher_certificates_cubit/teacher_certificates_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/teacher_certificates_cubit/teacher_certificates_state.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/teacher_certificate_issue_action.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/teacher_certificates_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherCertificatesBody extends StatelessWidget {
  const TeacherCertificatesBody({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<TeacherCertificatesCubit, TeacherCertificatesState>(
        listenWhen: (previous, current) => previous.eventId != current.eventId,
        listener: (context, state) =>
            showCustomSnackBar(context, state.eventMessage, state.eventSuccess),
        builder: (_, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const TeacherCertificateIssueAction(),
            Expanded(child: TeacherCertificatesContent(state: state)),
          ],
        ),
      );
}
