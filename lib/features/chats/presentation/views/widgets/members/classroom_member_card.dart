import 'package:bnan_app/core/shared_widget/custom_avatar.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/certificates_management/data/models/classroom_students_response_model.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/student_call_alert_action.dart';
import 'package:flutter/material.dart';

class ClassroomMemberCard extends StatelessWidget {
  const ClassroomMemberCard({super.key, required this.student});
  final ClassroomStudentModel student;

  @override
  Widget build(BuildContext context) {
    final id = student.id?.trim() ?? '';
    final name = student.fullName?.trim() ?? '';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorManager.greyF8F9,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorManager.greyE8E9),
      ),
      child: Row(
        children: [
          CustomAvatar(
            firstName: name,
            radius: 23,
            backgroundColor: ColorManager.blueE3,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: StylesManager.styleBold14(context),
            ),
          ),
          if (id.isNotEmpty)
            StudentCallAlertAction(
              studentId: id,
              color: ColorManager.mainColor0A,
            ),
        ],
      ),
    );
  }
}
