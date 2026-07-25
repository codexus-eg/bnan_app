import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/network/repos_and_cubit_exports.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/certificates_management/data/models/monthly_certificate_summary_model.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_classroom_students_cubit/get_classroom_students_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_student_subjects_cubit/get_student_subjects_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/dialogs/certificate_dialog.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/dialogs/certificate_preview_dialog.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/certificate_action_button.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/delete_certificates_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CertificateActions extends StatelessWidget {
  const CertificateActions({super.key, required this.certificate});

  final MonthlyCertificateSummaryModel certificate;

  @override
  Widget build(BuildContext context) {
    final studentName = certificate.studentName?.trim();
    final certificateId = certificate.id?.trim();

    return Padding(
      padding: const EdgeInsetsDirectional.all(8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  studentName?.isNotEmpty == true ? studentName! : '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: StylesManager.styleBold12(
                    context,
                  ).copyWith(color: ColorManager.greyA8AF),
                ),
                const SizedBox(height: 4),
                Text(
                  certificate.gradeName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: StylesManager.styleRegular10(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
              ],
            ),
          ),
          CertificateActionButton(
            title: S.of(context).preview,
            onTap: () => _showPreview(context),
          ),
          const SizedBox(width: 17),
          CertificateActionButton(
            title: S.of(context).edit,
            onTap: () => _showEditDialog(context, certificateId),
          ),
          const SizedBox(width: 17),
          if (certificateId?.isNotEmpty == true)
            DeleteCertificatesSection(certificateId: certificateId!),
        ],
      ),
    );
  }

  void _showPreview(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha((255 * .72).round()),
      builder: (_) => CertificatePreviewDialog(
        imageUrl: certificate.previewImagePath ?? '',
        pdfUrl: certificate.pdfPath ?? '',
      ),
    );
  }

  void _showEditDialog(BuildContext context, String? certificateId) {
    showDialog(
      context: context,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AcademicLookupsCubit(
              repo: getIt<AcademicLookupsRepo>(),
              loadClassroomsOnGrade: true,
              loadSubjectsWithoutClassroom: true,
            )..loadCurriculums(),
          ),
          BlocProvider(create: (_) => getIt<GetCertificateDetailsCubit>()),
          BlocProvider(create: (_) => getIt<GetClassroomStudentsCubit>()),
          BlocProvider(create: (_) => getIt<GetStudentSubjectsCubit>()),
          BlocProvider.value(
            value: context.read<UpdateMonthlyCertificateCubit>(),
          ),
          BlocProvider.value(
            value: context.read<GetMonthlyCertificatesCubit>(),
          ),
        ],
        child: CertificateDialog(isEdit: true, certificateId: certificateId),
      ),
    );
  }
}
