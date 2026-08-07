import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/teacher_request_groups/data/models/registration_request_model.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/views/widgets/registration_requests/name_and_time.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/views/widgets/registration_requests/registration_request_info_row.dart';
import 'package:flutter/material.dart';

class RequestDetails extends StatelessWidget {
  const RequestDetails({super.key, required this.request});
  final RegistrationRequestModel request;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NameAndTime(request: request),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            RegistrationRequestInfoRow(
              iconPath: ImageManager.teacherBookOneIcon,
              text: request.subjectName,
            ),
            RegistrationRequestInfoRow(
              iconPath: ImageManager.teacherGraduationCapIcon,
              text: request.gradeName,
            ),
            RegistrationRequestInfoRow(
              iconPath: ImageManager.teacherCurriculm,
              text: request.curriculumName,
            ),
            if (request.notes != null)
              RegistrationRequestInfoRow(
                iconPath: ImageManager.teacherNote,
                text: request.notes!,
                textColor: ColorManager.mainColor14,
              ),
          ],
        ),
      ],
    );
  }
}
