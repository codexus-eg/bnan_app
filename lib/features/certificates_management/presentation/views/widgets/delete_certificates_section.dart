import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/delete_monthly_certificate_cubit/delete_monthly_certificate_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/delete_monthly_certificate_cubit/delete_monthly_certificate_state.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_monthly_certificates_cubit/get_monthly_certificates_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:bnan_app/features/certificates_management/presentation/views/dialogs/certificate_delete_confirm_dialog.dart';

class DeleteCertificatesSection extends StatelessWidget {
  const DeleteCertificatesSection({super.key, required this.certificateId});

  final String certificateId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      DeleteMonthlyCertificateCubit,
      DeleteMonthlyCertificateState
    >(
      listener: (context, state) {
        if (state is DeleteMonthlyCertificateSuccess) {
          GetMonthlyCertificatesCubit.get(context).getMonthlyCertificates();

          showCustomSnackBar(
            context,
            S.of(context).certificateDeletedSuccessfully,
            true,
          );
        }

        if (state is DeleteMonthlyCertificateFailure) {
          showCustomSnackBar(context, state.message, false);
        }
      },
      builder: (context, state) {
        final isLoading = state is DeleteMonthlyCertificateLoading;

        return InkWell(
          onTap: isLoading
              ? null
              : () => _confirm(context),
          child: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : SvgPicture.asset(ImageManager.trash),
        );
      },
    );
  }

  void _confirm(BuildContext context) {
    final cubit = DeleteMonthlyCertificateCubit.get(context);
    showDialog(
      context: context,
      builder: (_) => CertificateDeleteConfirmDialog(
        onConfirm: () => cubit.deleteMonthlyCertificate(
          certificateId: certificateId,
        ),
      ),
    );
  }
}
