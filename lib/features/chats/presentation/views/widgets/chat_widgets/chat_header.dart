import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/chats/presentation/models/classroom_documents_route_args.dart';
import 'package:bnan_app/features/chats/presentation/models/classroom_members_route_args.dart';
import 'package:bnan_app/features/chats/presentation/policies/classroom_documents_access.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/user_info.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/chat_session_action.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/student_call_alert_action.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/policies/change_request_access_policy.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/widgets/classroom_change_request_action.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({
    super.key,
    required this.chatTitle,
    required this.roomId,
    this.roomType,
    this.classroomId,
    this.classroomSubjectId,
    this.currentUserRole,
    this.studentId,
    this.onMessageTarget,
    this.selectedCount = 0,
    this.isDeleting = false,
    this.onCancelSelection,
    this.onDeleteSelection,
  });
  final String chatTitle;
  final String roomId;
  final String? roomType;
  final String? classroomId;
  final String? classroomSubjectId;
  final String? currentUserRole;
  final String? studentId;
  final ValueChanged<String>? onMessageTarget;
  final int selectedCount;
  final bool isDeleting;
  final VoidCallback? onCancelSelection;
  final VoidCallback? onDeleteSelection;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.only(
        top: 19,
        // start: 16,
        end: 16,
        bottom: 19,
      ),
      decoration: const BoxDecoration(
        color: ColorManager.mainColor14,
        borderRadius: BorderRadiusDirectional.only(
          bottomStart: Radius.circular(10),
          bottomEnd: Radius.circular(10),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              onPressed: selectedCount > 0
                  ? onCancelSelection
                  : () => MyNavigator.pop(context),
              icon: Icon(
                selectedCount > 0 ? Icons.close : _backIcon(context),
                color: ColorManager.white,
              ),
            ),
            Expanded(
              child: selectedCount > 0
                  ? Text(
                      '$selectedCount ${S.of(context).selectedMessagesLabel}',
                      style: const TextStyle(color: ColorManager.white),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) =>
                          _responsiveContent(context, constraints),
                    ),
            ),
            if (selectedCount > 0)
              IconButton(
                onPressed: isDeleting ? null : onDeleteSelection,
                icon: isDeleting
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ColorManager.white,
                        ),
                      )
                    : const Icon(
                        Icons.delete_outline,
                        color: ColorManager.white,
                      ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _responsiveContent(BuildContext context, BoxConstraints constraints) {
    final actions = _actions(context);
    final info = UserInfo(chatTitle: chatTitle);
    if (actions.isEmpty) return info;
    final actionsWidth = (constraints.maxWidth - 64).clamp(
      0.0,
      constraints.maxWidth,
    );
    return Row(
      children: [
        Expanded(child: info),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: actionsWidth),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerEnd,
            child: Row(mainAxisSize: MainAxisSize.min, children: actions),
          ),
        ),
      ],
    );
  }

  List<Widget> _actions(BuildContext context) => [
    if (_sessionRole == UserRole.supervisor &&
        roomType == 'supervisor_student' &&
        studentId?.trim().isNotEmpty == true)
      StudentCallAlertAction(studentId: studentId!.trim()),
    if (_sessionRole != null && classroomId?.trim().isNotEmpty == true)
      ChatSessionAction(
        classroomId: classroomId!.trim(),
        roomId: roomId,
        role: _sessionRole!,
      ),
    if (classroomId?.trim().isNotEmpty == true &&
        ChangeRequestAccessPolicy.canShow(
          role: _sessionRole,
          roomType: roomType,
        ))
      ClassroomChangeRequestAction(
        classroomId: classroomId!.trim(),
        classroomSubjectId: classroomSubjectId?.trim(),
        role: _sessionRole!,
      ),
    if (_sessionRole == UserRole.supervisor &&
        roomType == 'classroom' &&
        classroomId?.trim().isNotEmpty == true)
      IconButton(
        key: const Key('classroomMembersButton'),
        tooltip: S.of(context).students,
        onPressed: () => _openMembers(context),
        icon: const Icon(Icons.group_outlined, color: ColorManager.white),
      ),
    if (ClassroomDocumentsAccess.canMessages(
      roomType: roomType,
      roomId: roomId,
      role: currentUserRole,
    ))
      IconButton(
        key: const Key('classroomDocumentsButton'),
        onPressed: () => _openDocuments(context),
        icon: const Icon(Icons.folder_copy_outlined, color: ColorManager.white),
      ),
  ];

  IconData _backIcon(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final platform = Theme.of(context).platform;

    if (platform == TargetPlatform.iOS) {
      return isRtl ? Icons.arrow_back_ios_new : Icons.arrow_back_ios_new;
    }

    return isRtl ? Icons.arrow_back : Icons.arrow_back;
  }

  UserRole? get _sessionRole {
    final role = UserRole.fromValue(currentUserRole);
    return const {
          UserRole.student,
          UserRole.teacher,
          UserRole.supervisor,
          UserRole.admin,
        }.contains(role)
        ? role
        : null;
  }

  Future<void> _openDocuments(BuildContext context) async {
    final messageId = await MyNavigator.goTo<String>(
      context,
      Routes.classroomDocuments,
      extra: ClassroomDocumentsRouteArgs(
        roomId: roomId.trim(),
        roomType: roomType,
        currentUserRole: currentUserRole,
        classroomId: classroomId?.trim(),
        classroomName: chatTitle,
      ),
    );
    if (messageId?.trim().isNotEmpty == true) onMessageTarget?.call(messageId!);
  }

  void _openMembers(BuildContext context) => MyNavigator.goTo<void>(
    context,
    Routes.classroomMembers,
    extra: ClassroomMembersRouteArgs(classroomId: classroomId!.trim()),
  );
}
