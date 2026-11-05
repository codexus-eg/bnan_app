import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_monthly_certificates_cubit/get_monthly_certificates_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/issue_monthly_certificates_cubit/issue_monthly_certificates_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/issue_monthly_certificates_cubit/issue_monthly_certificates_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bnan_app/features/certificates_management/presentation/views/dialogs/certificate_issue_confirm_dialog.dart';

class IssueMonthlyCertificatesWidget extends StatelessWidget {
  const IssueMonthlyCertificatesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:
          BlocConsumer<
            IssueMonthlyCertificatesCubit,
            IssueMonthlyCertificatesState
          >(
            listener: (context, state) {
              if (state is IssueMonthlyCertificatesSuccess) {
                showCustomSnackBar(
                  context,
                  S.of(context).certificatesSentSuccessfully,
                  true,
                );
                GetMonthlyCertificatesCubit.get(
                  context,
                ).getMonthlyCertificates();
              }

              if (state is IssueMonthlyCertificatesFailure) {
                showCustomSnackBar(context, state.message, false);
              }
            },
            builder: (context, state) {
              final isLoading = state is IssueMonthlyCertificatesLoading;

              return AddNewTopicButton(
                title: isLoading
                    ? S.of(context).sending
                    : S.of(context).sendAll,
                onTap: isLoading
                    ? null
                    : () => _confirm(context),
                path: ImageManager.tablerSendIcon,
              );
            },
          ),
    );
  }

  void _confirm(BuildContext context) {
    final cubit = IssueMonthlyCertificatesCubit.get(context);
    showDialog(
      context: context,
      builder: (_) => CertificateIssueConfirmDialog(
        onConfirm: () => cubit.issueMonthlyCertificates(),
      ),
    );
  }
}
