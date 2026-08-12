import 'package:bnan_app/core/helper/file_url_launcher.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/action_chip.dart';
import 'package:bnan_app/core/shared_widget/card_header.dart';
import 'package:bnan_app/core/shared_widget/class_meta_row.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/info_text.dart';
import 'package:bnan_app/core/shared_widget/status_action_button.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/teacher_application/data/models/teacher_request_model.dart';
import 'package:bnan_app/features/teacher_application/presentation/manager/pending_teacher_requests_cubit/pending_teacher_requests_cubit.dart';
import 'package:bnan_app/features/teacher_application/presentation/manager/teacher_request_actions_cubit/teacher_request_actions_cubit.dart';
import 'package:bnan_app/features/teacher_application/presentation/manager/teacher_request_actions_cubit/teacher_request_actions_state.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/teacher_application_details_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherApplicationCard extends StatelessWidget {
  const TeacherApplicationCard({super.key, required this.teacher});

  final TeacherRequestModel teacher;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocConsumer<TeacherRequestActionsCubit, TeacherRequestActionsState>(
      listener: (context, state) {
        if (state is ApproveTeacherRequestSuccess) {
          context
              .read<PendingTeacherRequestsCubit>()
              .getPendingTeacherRequests();
        }

        if (state is RejectTeacherRequestSuccess) {
          context
              .read<PendingTeacherRequestsCubit>()
              .getPendingTeacherRequests();
        }

        if (state is TeacherRequestActionsFailure) {
          showCustomSnackBar(context, state.message, false);
        }
      },
      builder: (context, state) {
        return CustomDetailsWidgetBackground(
          child: Column(
            children: [
              CardHeader(
                name: teacher.user.fullName,
                phone: teacher.phone,
                subtitle: teacher.status,
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClassMetaRow(
                      label: '${s.specialization}: ',
                      value: teacher.specialization,
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: InfoText(
                      label: s.experience,
                      value: teacher.hasTeachingExperience ? s.yes : s.no,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatusActionButton(
                    title: s.accept,
                    icon: Icons.check,
                    backgroundColor: ColorManager.orangeF9,
                    onPressed: () {
                      context
                          .read<TeacherRequestActionsCubit>()
                          .approveTeacherRequest(teacher.id);
                    },
                  ),
                  StatusActionButton(
                    onPressed: () {
                      context
                          .read<TeacherRequestActionsCubit>()
                          .rejectTeacherRequest(teacher.id);
                    },
                  ),
                  ActionChipButton(
                    title: s.cv,
                    icon: ImageManager.fileIcon,
                    onTap: () => _openCv(context),
                  ),
                  ActionChipButton(
                    title: s.details,
                    icon: ImageManager.usersManagementEyeOpenIcon,
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) =>
                          TeacherApplicationDetailsDialog(teacher: teacher),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openCv(BuildContext context) async {
    final cv = teacher.cv.trim();
    if (cv.isEmpty) {
      showCustomSnackBar(context, S.of(context).cvUnavailable, false);
      return;
    }
    if (!FileUrlLauncher.isValidWebUrl(cv)) {
      showCustomSnackBar(context, S.of(context).invalidCvUrl, false);
      return;
    }

    final opened = await FileUrlLauncher.open(cv);
    if (!opened && context.mounted) {
      showCustomSnackBar(context, S.of(context).failedToOpenCv, false);
    }
  }
}
