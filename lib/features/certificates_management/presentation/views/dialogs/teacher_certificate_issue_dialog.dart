import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/teacher_certificates_cubit/teacher_certificates_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/teacher_certificates_cubit/teacher_certificates_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherCertificateIssueDialog extends StatefulWidget {
  const TeacherCertificateIssueDialog({super.key});
  @override
  State<TeacherCertificateIssueDialog> createState() => _IssueDialogState();
}

class _IssueDialogState extends State<TeacherCertificateIssueDialog> {
  String? teacherId;
  late final int initialEventId;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<TeacherCertificatesCubit>();
    initialEventId = cubit.state.eventId;
    cubit.loadTeachers();
  }

  @override
  Widget build(
    BuildContext context,
  ) => BlocConsumer<TeacherCertificatesCubit, TeacherCertificatesState>(
    listener: (context, state) {
      if (state.eventId > initialEventId && state.eventSuccess) {
        Navigator.pop(context);
      }
    },
    builder: (context, state) => CustomAppDialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDialogHeader(title: S.of(context).generalTeacherCertificate),
            const SizedBox(height: 16),
            CustomDropdown(
              label: S.of(context).teacher,
              hint: state.loadingTeachers
                  ? S.of(context).loading
                  : S.of(context).selectTeacher,
              value: teacherId,
              items: state.teachers.map((teacher) => teacher.id).toList(),
              itemsLabels: {
                for (final teacher in state.teachers) teacher.id: teacher.name,
              },
              onChanged: (value) => setState(() => teacherId = value),
            ),
            if (!state.loadingTeachers && state.teachers.isEmpty) ...[
              const SizedBox(height: 8),
              Text(S.of(context).noTeachersAvailable),
            ],
            const SizedBox(height: 16),
            CustomAppButton(
              text: S.of(context).issueNewCertificate,
              isLoading: state.issuing,
              onPressed: teacherId == null ? null : () => _issue(context),
            ),
          ],
        ),
      ),
    ),
  );

  void _issue(BuildContext context) => context
      .read<TeacherCertificatesCubit>()
      .issue(teacherId!, SessionManager.instance.userName ?? '');
}
