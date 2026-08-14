import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/student_subject_request.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/widgets/subject_request_actions.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/widgets/subject_request_status_label.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SubjectRequestCard extends StatelessWidget {
  const SubjectRequestCard({
    super.key,
    required this.request,
    this.onClassroom,
    this.onChat,
  });

  final StudentSubjectRequest request;
  final VoidCallback? onClassroom;
  final VoidCallback? onChat;

  @override
  Widget build(BuildContext context) {
    final teacherName = request.teacher?.name.trim() ?? '';
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorManager.white,
        border: Border.all(color: ColorManager.borderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            request.subject?.name ?? '',
            style: StylesManager.styleBold14(context),
          ),
          const SizedBox(height: 4),
          Text(
            subjectRequestStatusLabel(S.of(context), request.status),
            style: StylesManager.styleRegular14(
              context,
            ).copyWith(color: ColorManager.mainColor14),
          ),
          if (request.status == 'assigned' && teacherName.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              '${S.of(context).teacher}: $teacherName',
              style: StylesManager.styleRegular14(context),
            ),
          ],
          if (onClassroom != null || onChat != null) ...[
            const SizedBox(height: 12),
            SubjectRequestActions(onClassroom: onClassroom, onChat: onChat),
          ],
        ],
      ),
    );
  }
}
