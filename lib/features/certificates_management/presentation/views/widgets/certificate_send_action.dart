import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/create_monthly_certificate_cubit/create_monthly_certificate_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_classroom_students_cubit/get_classroom_students_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_monthly_certificates_cubit/get_monthly_certificates_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_student_subjects_cubit/get_student_subjects_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/dialogs/certificate_dialog.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/issue_monthly_certificates_widget.dart';
import 'package:bnan_app/features/supervisor_management/presentation/manager/get_supervisor_classrooms/get_supervisor_classrooms_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CertificatesSendActions extends StatelessWidget {
  const CertificatesSendActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 16, end: 16, start: 16),
      child: Row(
        children: [
          IssueMonthlyCertificatesWidget(),
          const SizedBox(width: 19),
          Expanded(
            child: AddNewTopicButton(
              title: S.of(context).issueNewCertificate,
              onTap: () {
                final createCertificate = context
                    .read<CreateMonthlyCertificateCubit>();
                showDialog(
                  context: context,
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: createCertificate),
                      BlocProvider(
                        create: (_) =>
                            getIt<GetSupervisorClassroomsCubit>()
                              ..getMyClassrooms(),
                      ),
                      BlocProvider(
                        create: (_) => getIt<GetClassroomStudentsCubit>(),
                      ),
                      BlocProvider(
                        create: (_) => getIt<GetStudentSubjectsCubit>(),
                      ),
                      BlocProvider.value(
                        value: context.read<GetMonthlyCertificatesCubit>(),
                      ),
                    ],
                    child: const CertificateDialog(),
                  ),
                );
              },
              path: ImageManager.plus,
            ),
          ),
        ],
      ),
    );
  }
}
