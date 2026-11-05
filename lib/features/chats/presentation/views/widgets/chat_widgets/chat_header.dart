import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/chat_search_state.dart';
import 'package:bnan_app/features/chats/presentation/models/classroom_documents_route_args.dart';
import 'package:bnan_app/features/chats/presentation/models/classroom_members_route_args.dart';
import 'package:bnan_app/features/chats/presentation/policies/classroom_documents_access.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/user_info.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/chat_session_action.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/student_call_alert_action.dart';
import 'package:bnan_app/features/lessons_management/presentation/models/lessons_management_args.dart';
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
    this.accessScope,
    this.classroomSubjectId,
    this.canRequestTeacherWithdrawal,
    this.classroomSubjectAmbiguous,
    this.currentUserRole,
    this.studentId,
    this.onMessageTarget,
    this.onSearch,
    this.searchState,
    this.onSearchQueryChanged,
    this.onNextSearch,
    this.onPreviousSearch,
    this.onCloseSearch,
    this.selectedCount = 0,
    this.isDeleting = false,
    this.canEditSelected = false,
    this.onCancelSelection,
    this.onDeleteSelection,
    this.onEditSelection,
  });

  final String chatTitle;
  final String roomId;
  final String? roomType;
  final String? classroomId;
  final String? accessScope;
  final String? classroomSubjectId;
  final bool? canRequestTeacherWithdrawal;
  final bool? classroomSubjectAmbiguous;
  final String? currentUserRole;
  final String? studentId;
  final ValueChanged<String>? onMessageTarget;
  final VoidCallback? onSearch;
  final ChatSearchState? searchState;
  final ValueChanged<String>? onSearchQueryChanged;
  final VoidCallback? onNextSearch;
  final VoidCallback? onPreviousSearch;
  final VoidCallback? onCloseSearch;
  final int selectedCount;
  final bool isDeleting;
  final bool canEditSelected;
  final VoidCallback? onCancelSelection;
  final VoidCallback? onDeleteSelection;
  final VoidCallback? onEditSelection;

  @override
  Widget build(BuildContext context) {
    final isSearching = searchState?.isSearching == true;

    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.only(top: 19, end: 16, bottom: 19),
      decoration: const BoxDecoration(
        color: ColorManager.mainColor14,
        borderRadius: BorderRadiusDirectional.only(
          bottomStart: Radius.circular(10),
          bottomEnd: Radius.circular(10),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: selectedCount > 0
            ? _buildSelectionContent(context)
            : isSearching
            ? _buildSearchContent(context)
            : _buildStandardContent(context),
      ),
    );
  }

  Widget _buildSelectionContent(BuildContext context) => Row(
    children: [
      IconButton(
        onPressed: onCancelSelection,
        icon: const Icon(Icons.close, color: ColorManager.white),
      ),
      Expanded(
        child: Text(
          '$selectedCount ${S.of(context).selectedMessagesLabel}',
          style: const TextStyle(color: ColorManager.white),
        ),
      ),
      if (canEditSelected && selectedCount == 1)
        IconButton(
          onPressed: isDeleting ? null : onEditSelection,
          icon: const Icon(Icons.edit_outlined, color: ColorManager.white),
        ),
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
            : const Icon(Icons.delete_outline, color: ColorManager.white),
      ),
    ],
  );

  Widget _buildSearchContent(BuildContext context) {
    final search = searchState ?? const ChatSearchState();
    final count = search.resultMessageIds.length;
    final index = search.currentIndex;
    final counterText = search.searchQuery.isEmpty
        ? ''
        : count > 0
        ? '${index + 1} / $count'
        : S.of(context).chatSearchNoResults;

    return Row(
      children: [
        IconButton(
          tooltip: S.of(context).close,
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            onCloseSearch?.call();
          },
          icon: const Icon(Icons.close, color: ColorManager.white),
        ),
        Expanded(
          child: SizedBox(
            height: 38,
            child: TextField(
              autofocus: true,
              style: StylesManager.styleRegular14(
                context,
              ).copyWith(color: ColorManager.black),
              decoration: InputDecoration(
                hintText: S.of(context).chatSearchHint,
                hintStyle: StylesManager.styleLight12(
                  context,
                ).copyWith(color: ColorManager.grey7A7C),
                filled: true,
                fillColor: ColorManager.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: onSearchQueryChanged,
            ),
          ),
        ),
        if (counterText.isNotEmpty) ...[
          const SizedBox(width: 8),
          Text(
            counterText,
            style: StylesManager.styleRegular12(
              context,
            ).copyWith(color: ColorManager.white),
          ),
        ],
        if (count > 0) ...[
          IconButton(
            tooltip: S.of(context).previous,
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            onPressed: onPreviousSearch,
            icon: const Icon(
              Icons.keyboard_arrow_up,
              color: ColorManager.white,
            ),
          ),
          IconButton(
            tooltip: S.of(context).next,
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            onPressed: onNextSearch,
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: ColorManager.white,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStandardContent(BuildContext context) => Row(
    children: [
      IconButton(
        onPressed: () => MyNavigator.pop(context),
        icon: Icon(_backIcon(context), color: ColorManager.white),
      ),
      Expanded(
        child: LayoutBuilder(
          builder: (context, constraints) =>
              _responsiveContent(context, constraints),
        ),
      ),
    ],
  );

  Widget _responsiveContent(BuildContext context, BoxConstraints constraints) {
    final actions = _actions(context);
    final info = UserInfo(
      chatTitle: chatTitle,
      onViewSchedule: _canViewSchedule ? () => _openSchedule(context) : null,
    );
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
    if (onSearch != null)
      IconButton(
        key: const Key('chatSearchButton'),
        tooltip: S.of(context).chatSearchHint,
        onPressed: onSearch,
        icon: const Icon(Icons.search, color: ColorManager.white),
      ),
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
          accessScope: accessScope,
          classroomSubjectId: classroomSubjectId,
          canRequestTeacherWithdrawal: canRequestTeacherWithdrawal,
          classroomSubjectAmbiguous: classroomSubjectAmbiguous,
        ))
      ClassroomChangeRequestAction(
        classroomId: classroomId!.trim(),
        classroomSubjectId: classroomSubjectId?.trim(),
        classroomSubjectAmbiguous: classroomSubjectAmbiguous == true,
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

  bool get _canViewSchedule {
    if (classroomId?.trim().isNotEmpty != true) return false;
    final role = _sessionRole;
    return role == UserRole.teacher ||
        role == UserRole.supervisor ||
        role == UserRole.admin;
  }

  void _openSchedule(BuildContext context) {
    final id = classroomId?.trim();
    if (id == null || id.isEmpty) return;
    final session = SessionManager.instance;
    final route = (session.role == UserRole.admin || session.isEgyptianSupervisor)
        ? Routes.tablesManagement
        : Routes.lessonsManagement;
    MyNavigator.goTo<void>(
      context,
      route,
      extra: LessonsManagementArgs(initialClassId: id),
    );
  }
}
