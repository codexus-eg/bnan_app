import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/certificates_management/data/models/monthly_certificate_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/requests/certificate_subject_request_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/requests/update_monthly_certificate_request_model.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_certificate_details_cubit/get_certificate_details_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_certificate_details_cubit/get_certificate_details_state.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_monthly_certificates_cubit/get_monthly_certificates_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/update_monthly_certificate_cubit/update_monthly_certificate_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/update_monthly_certificate_cubit/update_monthly_certificate_state.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/certificate_edit_subjects_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CertificateEditForm extends StatefulWidget {
  const CertificateEditForm({
    super.key,
    required this.title,
    required this.certificateId,
  });

  final String title;
  final String certificateId;

  @override
  State<CertificateEditForm> createState() => _CertificateEditFormState();
}

class _CertificateEditFormState extends State<CertificateEditForm> {
  List<CertificateSubjectRequestModel> subjectRequests = [];
  String? formError;

  @override
  void initState() {
    super.initState();

    context.read<GetCertificateDetailsCubit>().getCertificateDetails(
      certificateId: widget.certificateId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      UpdateMonthlyCertificateCubit,
      UpdateMonthlyCertificateState
    >(
      listener: _updateListener,
      child:
          BlocBuilder<GetCertificateDetailsCubit, GetCertificateDetailsState>(
            builder: (context, state) {
              if (state is GetCertificateDetailsFailure) {
                return _buildFailure(state.message);
              }

              final certificate = state is GetCertificateDetailsSuccess
                  ? state.response.data
                  : null;

              return AppSkeletonizer(
                isLoading: state is GetCertificateDetailsLoading,
                child: _buildBody(certificate),
              );
            },
          ),
    );
  }

  Widget _buildBody(MonthlyCertificateModel? certificate) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDialogHeader(title: widget.title),
        const SizedBox(height: 16),
        CertificateEditSubjectsSection(
          certificate: certificate,
          onChanged: (subjects) {
            subjectRequests = subjects;

            if (formError != null) {
              setState(() {
                formError = null;
              });
            }
          },
        ),
        const SizedBox(height: 16),
        if (formError != null) ...[
          Center(
            child: Text(
              formError!,
              style: StylesManager.styleRegular14(
                context,
              ).copyWith(color: Colors.red),
            ),
          ),
          const SizedBox(height: 8),
        ],
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildFailure(String message) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomDialogHeader(title: widget.title),
        const SizedBox(height: 16),
        Text(
          message,
          style: StylesManager.styleRegular14(
            context,
          ).copyWith(color: Colors.red),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return BlocBuilder<
      UpdateMonthlyCertificateCubit,
      UpdateMonthlyCertificateState
    >(
      builder: (context, state) {
        return CustomAppButton(
          text: S.of(context).save,
          isLoading: state is UpdateMonthlyCertificateLoading,
          onPressed: _save,
        );
      },
    );
  }

  void _save() {
    if (subjectRequests.isEmpty) {
      setState(() {
        formError = S.of(context).pleaseEnterSubjectsGrades;
      });
      return;
    }

    context.read<UpdateMonthlyCertificateCubit>().updateMonthlyCertificate(
      certificateId: widget.certificateId,
      request: UpdateMonthlyCertificateRequestModel(subjects: subjectRequests),
    );
  }

  void _updateListener(
    BuildContext context,
    UpdateMonthlyCertificateState state,
  ) {
    if (state is UpdateMonthlyCertificateSuccess) {
      context
      .read<GetMonthlyCertificatesCubit>()
      .getMonthlyCertificates();

      Navigator.pop(context);

      showCustomSnackBar(
        context,
        S.of(context).certificateUpdatedSuccessfully,
        true,
      );
      return;
    }

    if (state is UpdateMonthlyCertificateFailure) {
      setState(() {
        formError = state.message;
      });
    }
  }
}
