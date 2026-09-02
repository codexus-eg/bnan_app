import 'package:bnan_app/core/helper/file_picker_helper.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_state.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_attachments_data/teacher_upload_file_card.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_attachments_data/teacher_internet_proof_card.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_attachments_data/teacher_experience_certificates_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherUploadFilesSection extends StatelessWidget {
  const TeacherUploadFilesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherRegistrationCubit, TeacherRegistrationState>(
      builder: (context, state) {
        final cubit = TeacherRegistrationCubit.get(context);

        return Column(
          children: [
            TeacherUploadFileCard(
              title: S.of(context).uploadCvFile,
              file: cubit.cvFile,
              onTap: () async {
                final file = await FilePickerHelper.pickFile();

                if (file != null) {
                  cubit.changeCvFile(file);
                }
              },
            ),
            const SizedBox(height: 16),
            TeacherUploadFileCard(
              title: S.of(context).uploadCertificateFile,
              file: cubit.certificateFile,
              onTap: () async {
                final file = await FilePickerHelper.pickFile();

                if (file != null) {
                  cubit.changeCertificateFile(file);
                }
              },
            ),
            const SizedBox(height: 16),
            TeacherUploadFileCard(
              title: S.of(context).uploadNationalIdFile,
              file: cubit.nationalIdFile,
              onTap: () async {
                final file = await FilePickerHelper.pickFile();

                if (file != null) {
                  cubit.changeNationalIdFile(file);
                }
              },
            ),
            const SizedBox(height: 16),
            TeacherInternetProofCard(
              file: cubit.stableInternetProofFile,
              onTap: () => _pickInternetProof(context, cubit),
            ),
            const SizedBox(height: 16),
            TeacherExperienceCertificatesCard(
              files: cubit.experienceCertificateFiles,
              onTap: () => _pickExperienceCertificates(context, cubit),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickInternetProof(
    BuildContext context,
    TeacherRegistrationCubit cubit,
  ) async {
    final file = await FilePickerHelper.pickFile(
      allowedExtensions: const ['png', 'jpg', 'jpeg', 'webp'],
    );
    if (file == null) return;
    final isTooLarge = await file.length() > 5 * 1024 * 1024;
    if (!context.mounted) return;
    if (isTooLarge) {
      showCustomSnackBar(
        context,
        S.of(context).stableInternetProofTooLarge,
        false,
      );
      return;
    }
    cubit.changeStableInternetProof(file);
  }

  Future<void> _pickExperienceCertificates(
    BuildContext context,
    TeacherRegistrationCubit cubit,
  ) async {
    final files = await FilePickerHelper.pickFiles();
    if (!context.mounted || files.isEmpty) return;
    if (files.length > 10) {
      showCustomSnackBar(
        context,
        S.of(context).experienceCertificatesLimit,
        false,
      );
    }
    cubit.changeExperienceCertificates(files);
  }
}
