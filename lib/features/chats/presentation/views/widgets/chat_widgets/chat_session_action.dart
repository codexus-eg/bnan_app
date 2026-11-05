import 'dart:async';

import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/helper/file_url_launcher.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/schedule_time_utils.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/teacher_session_subject_picker.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_state.dart';
import 'package:bnan_app/features/lessons_management/presentation/utils/student_join_session_error.dart';
import 'package:bnan_app/features/lessons_management/presentation/utils/zoom_session_error_handler.dart';
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
  bool _isStarting = false;
  Timer? endStatusTimer;
  Timer? _schedulePollTimer;
  Timer? _transitionPollTimer;

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
    _stopTransitionPolling();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refresh();
    }
  }

  @override
  void didUpdateWidget(ChatSessionAction oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.classroomId != widget.classroomId ||
        oldWidget.roomId != widget.roomId ||
        oldWidget.role != widget.role) {
      _stopTransitionPolling();
      _refresh();
    }
  }

  void _refresh() {
    if (!mounted) return;
    final cubit = context.read<StartSessionCubit>();
    unawaited(cubit.loadActive(widget.classroomId));
    unawaited(cubit.loadScheduledLessons());
  }

  void _startTransitionPolling() {
    if (_transitionPollTimer != null && _transitionPollTimer!.isActive) return;
    _transitionPollTimer?.cancel();
    _transitionPollTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) async {
        if (!mounted) {
          _stopTransitionPolling();
          return;
        }
        final cubit = context.read<StartSessionCubit>();
        await cubit.loadActive(widget.classroomId);
        if (!mounted) return;
        final status = cubit.state
            .active(widget.classroomId)
            ?.session
            .status
            .trim()
            .toLowerCase();
        if (status != 'starting' && status != 'awaiting_zoom_end') {
          _stopTransitionPolling();
        }
      },
    );
  }

  void _stopTransitionPolling() {
    _transitionPollTimer?.cancel();
    _transitionPollTimer = null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (initialized) return;

    initialized = true;

    _refresh();

    _schedulePollTimer?.cancel();
    _schedulePollTimer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => _refresh(),
    );

    final initialStatus = context
        .read<StartSessionCubit>()
        .state
        .active(widget.classroomId)
        ?.session
        .status
        .trim()
        .toLowerCase();
    if (initialStatus == 'starting' || initialStatus == 'awaiting_zoom_end') {
      _startTransitionPolling();
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) => BlocConsumer<StartSessionCubit, StartSessionState>(
    listener: (context, state) {
      final active = state.active(widget.classroomId);
      final status = active?.session.status.trim().toLowerCase();
      if (status == 'starting' || status == 'awaiting_zoom_end') {
        _startTransitionPolling();
      } else {
        _stopTransitionPolling();
      }
    },
    builder: (context, state) {
      final id = widget.classroomId;
      final currentRoom = widget.roomId.trim();
      final active = state.active(id);
      final sessionRoom = active?.session.chatRoomId.trim() ?? '';
      final isSameChat = sessionRoom.isEmpty || sessionRoom == currentRoom;
      final isSessionLive =
          active != null && active.session.isLiveOrStarting && isSameChat;
      final isSessionScheduledDue = (active != null &&
              active.session.isScheduled &&
              (active.session.isStartAvailable || active.session.isDueNow) &&
              isSameChat) ||
          state.isScheduled(roomId: currentRoom, classroomId: id);
      final canEnterActive = isSessionLive;

      debugPrint(
        '[DEBUG ChatSessionAction] build -> '
        'currentChatId: $currentRoom, '
        'classroomId: $id, '
        'role: ${widget.role}, '
        'isChecking: ${state.isChecking(id)}, '
        'isLoading: ${state.isLoading(id)}, '
        'scheduledChatRoomIds: ${state.scheduledChatRoomIds}, '
        'scheduledClassroomIds: ${state.scheduledClassroomIds}, '
        'isScheduled: ${state.isScheduled(roomId: currentRoom, classroomId: id)}, '
        'isSessionLive: $isSessionLive, '
        'isSessionScheduledDue: $isSessionScheduledDue, '
        'activeSessionId: ${active?.session.id}, '
        'activeStatus: ${active?.session.status}, '
        'canStart: ${active?.session.canStart}, '
        'startStatus: ${active?.session.startStatus}, '
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

      if (widget.role == UserRole.teacher || widget.role == UserRole.admin) {
        if (!isSessionLive) {
          if (active?.session.isAwaitingZoomEnd == true) {
            return _button(S.of(context).sessionEnding, null);
          }
          // قبل بدء الحصة: يظهر الزر فقط إذا كان هذا الشات هو شات الحصة المجدولة
          if (!isSessionScheduledDue) {
            return const SizedBox.shrink();
          }
          return _button(
            S.of(context).startSession,
            _isStarting ? null : _start,
          );
        }
        // بعد بدء الحصة: يظهر فقط إذا تطابق chatRoomId في الـ activeSession
        if (sessionRoom.isNotEmpty && sessionRoom != currentRoom) {
          return const SizedBox.shrink();
        }

        if (active.session.isAwaitingZoomEnd) {
          return _button(S.of(context).sessionEnding, null);
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _button(
              S.of(context).joinSession,
              () => _reenterTeacher(active.session.id),
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
          'isSameChat: $isSameChat, '
          'canEnterActive: $canEnterActive',
        );

        if (canEnterActive) {
          return _button(
            S.of(context).joinSession,
            () async {
              final cubit = context.read<StartSessionCubit>();
              final link = await cubit.join(
                widget.classroomId,
                weeklySlotKey: active.session.weeklySlotKey,
              );
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

      // student:
      if (active != null) {
        final sessionRoom = active.session.chatRoomId.trim();
        if (sessionRoom.isNotEmpty && sessionRoom != currentRoom) {
          return const SizedBox.shrink();
        }
      }

      if (widget.role == UserRole.student) {
        if (active?.session.isAwaitingZoomEnd == true) {
          return _button(S.of(context).sessionEnding, null);
        }
        if (active?.session.isStarting == true) {
          return _button(S.of(context).sessionStarting, null);
        }
        if (active?.session.studentCanJoin == true) {
          return _button(
            S.of(context).joinSession,
            () => _join(weeklySlotKey: active?.session.weeklySlotKey),
          );
        }
        return const SizedBox.shrink();
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
    if (_isStarting) return;
    _isStarting = true;
    try {
      final cubit = context.read<StartSessionCubit>();
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

      String? subjectId;
      if (subjects.isEmpty) {
        final fallbackSubject = cubit.state
            .active(widget.classroomId)
            ?.session
            .subjectId
            .trim();
        if (fallbackSubject != null && fallbackSubject.isNotEmpty) {
          subjectId = fallbackSubject;
        } else {
          return showCustomSnackBar(
            context,
            S.of(context).sessionSubjectUnavailable,
            false,
          );
        }
      } else {
        subjectId = subjects.length == 1
            ? subjects.single.id
            : await showTeacherSessionSubjectPicker(context, subjects);
      }

      if (!mounted || subjectId == null) return;
      final targetSubjectId = subjectId;

      final selectedSubject = subjects.length == 1
          ? subjects.single
          : subjects.firstWhere(
              (s) => s.id == targetSubjectId,
              orElse: () => TeacherAssignedSubjectModel(
                classroomSubjectId: '',
                id: targetSubjectId,
                name: '',
              ),
            );
      final dueLesson = cubit.state.dueLesson(
        classroomId: widget.classroomId,
        roomId: widget.roomId,
      );
      final activeSession = cubit.state.active(widget.classroomId)?.session;
      final occurrenceDate = dueLesson?.occurrenceDate ??
          activeSession?.resolvedOccurrenceDate ??
          ScheduleTimeUtils.formatIsoDate(DateTime.now());
      // Backend contract: Only Egyptian start requests use actual Egyptian lesson.id.
      // Gulf start requests must NOT include lessonId. Never substitute a session ID (activeSession.id) or Gulf schedule entry ID.
      final lessonId = dueLesson?.isEgyptian == true
          ? dueLesson?.lessonId?.trim()
          : null;
      final effectiveClassroomSubjectId =
          selectedSubject.classroomSubjectId.isNotEmpty
              ? selectedSubject.classroomSubjectId
              : (dueLesson?.classroomSubjectId ??
                  (activeSession?.classroomSubjectId ?? ''));

      final succeeded = await cubit.start(
        classroomId: widget.classroomId,
        subjectId: targetSubjectId,
        classroomSubjectId: effectiveClassroomSubjectId.isNotEmpty
            ? effectiveClassroomSubjectId
            : null,
        lessonId: lessonId,
        occurrenceDate: occurrenceDate,
        system: dueLesson?.system,
      );

      if (!mounted) return;

      if (!succeeded) {
        return _showSessionError(cubit.state);
      }

      final startUrl =
          cubit.state.active(widget.classroomId)?.teacherStartUrl ?? '';
      if (startUrl.isEmpty) {
        showCustomSnackBar(
          context,
          zoomSessionErrorMessage(
            context,
            cubit.state.copyWith(eventCode: 'TEACHER_START_URL_UNAVAILABLE'),
          ),
          false,
        );
        return;
      }

      await _open(startUrl);

      await cubit.loadActive(widget.classroomId);
    } finally {
      if (mounted) {
        setState(() => _isStarting = false);
      } else {
        _isStarting = false;
      }
    }
  }

  Future<void> _join({String? weeklySlotKey}) async {
    final cubit = context.read<StartSessionCubit>();

    final link = await cubit.join(
      widget.classroomId,
      weeklySlotKey: weeklySlotKey,
    );

    if (!mounted) return;

    if (link == null || link.isEmpty) {
      return _showSessionError(cubit.state);
    }

    await _open(link);
  }

  Future<void> _reenterTeacher(String sessionId) async {
    final cubit = context.read<StartSessionCubit>();
    final url = await cubit.getTeacherEntry(
      classroomId: widget.classroomId,
      sessionId: sessionId,
    );
    if (!mounted) return;
    if (url == null || url.isEmpty) {
      return _showSessionError(cubit.state);
    }
    await _open(url);
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
    final studentJoinError = widget.role == UserRole.student
        ? studentJoinSessionErrorMessage(context, state)
        : null;

    final message =
        studentJoinError ?? zoomSessionErrorMessage(context, state);

    showCustomSnackBar(context, message, false);

    final code =
        (state.eventCode ?? state.eventError ?? '').trim().toUpperCase();
    final shouldRefresh = code == 'CLASSROOM_SESSION_ALREADY_ACTIVE' ||
        code == 'SESSION_NOT_ACTIVE' ||
        code == 'WEEKLY_ZOOM_SLOT_SESSION_NOT_ACTIVE' ||
        code == 'SCHEDULE_OCCURRENCE_NOT_FOUND' ||
        code.startsWith('WEEKLY_ZOOM_ASSIGNMENT_') ||
        state.eventStatusCode == 404;
    if (shouldRefresh && mounted) {
      context.read<StartSessionCubit>().loadActive(widget.classroomId);
    }
  }
}
