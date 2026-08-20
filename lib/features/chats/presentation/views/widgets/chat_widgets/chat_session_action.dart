import 'dart:async';

import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/helper/file_url_launcher.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/teacher_session_subject_picker.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_state.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_assigned_subject_model.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assigned_subjects/get_teacher_assigned_subjects_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assigned_subjects/get_teacher_assigned_subjects_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChatSessionAction extends StatefulWidget {
  const ChatSessionAction({
    super.key,
    required this.classroomId,
    required this.roomId,
    required this.role,
  });

  final String classroomId;
  final String roomId;
  final UserRole role;

  @override
  State<ChatSessionAction> createState() => _ChatSessionActionState();
}

class _ChatSessionActionState extends State<ChatSessionAction>
    with WidgetsBindingObserver {
  bool initialized = false;
  Timer? endStatusTimer;
  Timer? _schedulePollTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    endStatusTimer?.cancel();
    _schedulePollTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refresh();
    }
  }

  void _refresh() {
    if (!mounted) return;
    final cubit = context.read<StartSessionCubit>();
    unawaited(cubit.loadActive(widget.classroomId));
    if (widget.role == UserRole.teacher) {
      unawaited(cubit.loadScheduledLessons());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (initialized) return;

    initialized = true;

    _refresh();

    if (widget.role == UserRole.teacher) {
      _schedulePollTimer?.cancel();
      _schedulePollTimer = Timer.periodic(
        const Duration(seconds: 30),
        (_) => _refresh(),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<StartSessionCubit, StartSessionState>(
    builder: (context, state) {
      final id = widget.classroomId;
      final currentRoom = widget.roomId.trim();
      final active = state.active(id);
      final sessionRoom = active?.session.chatRoomId.trim() ?? '';
      final isSameChat = sessionRoom.isEmpty || sessionRoom == currentRoom;
      final canEnterActive =
          active != null &&
          const {
            'starting',
            'live',
          }.contains(active.session.status.trim().toLowerCase()) &&
          isSameChat;

      debugPrint(
        '[DEBUG ChatSessionAction] build -> '
        'currentChatId: $currentRoom, '
        'classroomId: $id, '
        'role: ${widget.role}, '
        'isChecking: ${state.isChecking(id)}, '
        'isLoading: ${state.isLoading(id)}, '
        'scheduledChatRoomIds: ${state.scheduledChatRoomIds}, '
        'isScheduledChat: ${state.isScheduledChat(currentRoom)}, '
        'activeSession: ${active?.session.id}, '
        'activeChatRoomId: ${active?.session.chatRoomId}',
      );

      if (state.isLoading(id)) {
        return const Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 12),
          child: SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: ColorManager.white,
            ),
          ),
        );
      }

      if (widget.role == UserRole.teacher) {
        if (active == null) {
          // قبل بدء الحصة: يظهر الزر فقط إذا كان هذا الشات هو شات الحصة المجدولة
          if (!state.isScheduledChat(currentRoom)) {
            return const SizedBox.shrink();
          }
          return _button(S.of(context).startSession, _start);
        }
        // بعد بدء الحصة: يظهر فقط إذا تطابق chatRoomId في الـ activeSession
        final sessionRoom = active.session.chatRoomId.trim();
        if (sessionRoom.isNotEmpty && sessionRoom != currentRoom) {
          return const SizedBox.shrink();
        }

        if (active.session.status == 'awaiting_zoom_end') {
          return _button(S.of(context).sessionEnding, null);
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _button(
              S.of(context).joinSession,
              active.meetingLink.isNotEmpty
                  ? () => _open(active.meetingLink)
                  : _join,
            ),
            IconButton(
              tooltip: S.of(context).endSession,
              onPressed: _end,
              icon: const Icon(Icons.stop_circle_outlined),
              color: ColorManager.white,
            ),
          ],
        );
      }

      if (widget.role == UserRole.supervisor) {
        debugPrint(
          '[DEBUG ChatSessionAction] Supervisor check -> '
          'role: ${widget.role}, '
          'currentChatId: $currentRoom, '
          'classroomId: $id, '
          'activeSessionId: ${active?.session.id}, '
          'activeSessionStatus: ${active?.session.status}, '
          'activeChatRoomId: $sessionRoom, '
          'meetingLink: ${active?.meetingLink}, '
          'isSameChat: $isSameChat, '
          'canEnterActive: $canEnterActive',
        );

        if (canEnterActive) {
          return _button(
            S.of(context).joinSession,
            active.meetingLink.isNotEmpty
                ? () => _joinSupervisor(active.meetingLink)
                : () async {
                    final cubit = context.read<StartSessionCubit>();
                    final link = await cubit.join(widget.classroomId);
                    if (link != null && link.isNotEmpty) {
                      await _joinSupervisor(link);
                    } else if (mounted) {
                      _showSessionError(cubit.state);
                    }
                  },
          );
        }
        return const SizedBox.shrink();
      }

      // student / admin:
      if (active != null) {
        final sessionRoom = active.session.chatRoomId.trim();
        if (sessionRoom.isNotEmpty && sessionRoom != currentRoom) {
          return const SizedBox.shrink();
        }
      }

      if (widget.role == UserRole.student && canEnterActive) {
        return _button(S.of(context).joinSession, _join);
      }

      if (widget.role == UserRole.admin && canEnterActive) {
        return _button(
          S.of(context).joinSession,
          active.meetingLink.isNotEmpty
              ? () => _open(active.meetingLink)
              : _join,
        );
      }

      return const SizedBox.shrink();
    },
  );

  Widget _button(String label, VoidCallback? onPressed) => TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      foregroundColor: ColorManager.white,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
    ),
    child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
  );

  Future<void> _start() async {
    final subjectsCubit = context.read<GetTeacherAssignedSubjectsCubit>();

    await subjectsCubit.getTeacherAssignedSubjects(
      classroomId: widget.classroomId,
    );

    if (!mounted) return;

    final state = subjectsCubit.state;

    if (state is GetTeacherAssignedSubjectsFailure) {
      return showCustomSnackBar(context, state.errorMessage, false);
    }

    final List<TeacherAssignedSubjectModel> subjects =
        state is GetTeacherAssignedSubjectsSuccess
        ? state.response.data.subjects
        : const [];

    if (subjects.isEmpty) {
      return showCustomSnackBar(
        context,
        S.of(context).sessionSubjectUnavailable,
        false,
      );
    }

    final subjectId = subjects.length == 1
        ? subjects.single.id
        : await showTeacherSessionSubjectPicker(context, subjects);

    if (!mounted || subjectId == null) return;

    final cubit = context.read<StartSessionCubit>();

    final succeeded = await cubit.start(
      classroomId: widget.classroomId,
      subjectId: subjectId,
    );

    if (!mounted) return;

    if (!succeeded) {
      return _showSessionError(cubit.state);
    }

    final link = cubit.state.active(widget.classroomId)?.meetingLink ?? '';

    await _open(link);

    await cubit.loadActive(widget.classroomId);
  }

  Future<void> _join() async {
    final cubit = context.read<StartSessionCubit>();

    final link = await cubit.join(widget.classroomId);

    if (!mounted) return;

    if (link == null || link.isEmpty) {
      return _showSessionError(cubit.state);
    }

    await _open(link);
  }

  Future<void> _joinSupervisor(String link) async {
    await _open(link);

    if (!mounted) return;

    context.go(
      '${Routes.supervisorHome}?tab=${Uri.encodeComponent(Routes.attendance)}',
      extra: Routes.attendance,
    );
  }

  Future<void> _end() async {
    final cubit = context.read<StartSessionCubit>();

    if (!await cubit.end(widget.classroomId) && mounted) {
      _showSessionError(cubit.state);
      return;
    }

    if (mounted &&
        cubit.state.active(widget.classroomId)?.session.status ==
            'awaiting_zoom_end') {
      _pollAwaitingEnd(cubit);
    }
  }

  void _pollAwaitingEnd(StartSessionCubit cubit) {
    endStatusTimer?.cancel();

    endStatusTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (!mounted) {
        return timer.cancel();
      }

      await cubit.loadActive(widget.classroomId);

      if (cubit.state.active(widget.classroomId)?.session.status !=
          'awaiting_zoom_end') {
        timer.cancel();
      }
    });
  }

  Future<void> _open(String link) async {
    final opened =
        FileUrlLauncher.isValidWebUrl(link) && await FileUrlLauncher.open(link);

    if (mounted && !opened) {
      showCustomSnackBar(
        context,
        S.of(context).sessionStartedLinkOpenFailed,
        false,
      );
    }
  }

  void _showSessionError(StartSessionState state) {
    final code = state.eventCode ?? state.eventError;

    final message = switch (code) {
      'CLASSROOM_SESSION_ALREADY_ACTIVE' =>
        S.of(context).classroomSessionAlreadyActive,
      'SESSION_NOT_ACTIVE' => S.of(context).noActiveSessionNow,
      _ => state.eventError ?? S.of(context).unexpectedError,
    };

    showCustomSnackBar(context, message, false);
  }
}
