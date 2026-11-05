import 'package:bnan_app/features/certificates_management/data/models/teacher_certificate_model.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/teacher_certificates_cubit/teacher_certificates_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/dialogs/teacher_certificate_issue_confirm_dialog.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/teacher_certificate_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherCertificatesList extends StatelessWidget {
  const TeacherCertificatesList({
    super.key,
    required this.items,
    required this.loadingMore,
  });
  final List<TeacherCertificateModel> items;
  final bool loadingMore;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TeacherCertificatesCubit>();
    final issuingIds = context.select<TeacherCertificatesCubit, Set<String>>(
      (c) => c.state.issuingIds,
    );
    return RefreshIndicator(
      onRefresh: cubit.load,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.extentAfter < 200) {
            cubit.load(refresh: false);
          }
          return false;
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length + (loadingMore ? 1 : 0),
          itemBuilder: (_, index) {
            if (index == items.length) {
              return const Center(child: CircularProgressIndicator());
            }
            final cert = items[index];
            return TeacherCertificateCard(
              certificate: cert,
              isAdmin: cubit.isAdmin,
              isIssuing: issuingIds.contains(cert.id),
              onIssue: () =>
                  TeacherCertificateIssueConfirmDialog.show(context, cert),
            );
          },
        ),
      ),
    );
  }
}
