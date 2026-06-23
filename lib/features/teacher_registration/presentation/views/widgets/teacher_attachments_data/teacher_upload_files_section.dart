import 'package:bnan_app/core/helper/file_picker_helper.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_state.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_attachments_data/teacher_upload_file_card.dart';
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
          ],
        );
      },
    );
  }
}