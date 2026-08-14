import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/chats/presentation/models/chat_route_args.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/student_subject_request.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/widgets/subject_request_card.dart';
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
        ...requests.map((request) => _card(context, request)),
      ],
    );
  }

  Widget _card(BuildContext context, StudentSubjectRequest request) {
    final assigned = request.status == 'assigned';
    final classroomId = request.classroom?.id.trim() ?? '';
    final roomId = request.chatRoom?.id.trim() ?? '';
    return SubjectRequestCard(
      request: request,
      onClassroom: assigned && classroomId.isNotEmpty
          ? () => MyNavigator.goTo(context, Routes.studentGroups)
          : null,
      onChat: assigned && roomId.isNotEmpty
          ? () => MyNavigator.goTo(
              context,
              Routes.chatPath(roomId),
              extra: ChatRouteArgs(
                classroomId: classroomId,
                classroomName: request.classroom?.name,
                currentUserRole: SessionManager.instance.userRole,
              ),
            )
          : null,
    );
  }
}
