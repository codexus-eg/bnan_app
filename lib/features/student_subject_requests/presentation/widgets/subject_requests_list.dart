import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/student_subject_request.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/widgets/subject_request_status_label.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SubjectRequestsList extends StatelessWidget {
  const SubjectRequestsList({super.key, required this.requests});
  final List<StudentSubjectRequest> requests;

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) return const SizedBox.shrink();
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.subjectRequestMyRequests,
          style: StylesManager.styleBold14(context),
        ),
        const SizedBox(height: 8),
        ...requests.map(
          (request) => Container(
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
                  subjectRequestStatusLabel(s, request.status),
                  style: StylesManager.styleRegular14(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
