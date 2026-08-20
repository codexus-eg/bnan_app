import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/classroom_change_requests/data/repo/classroom_change_requests_repo.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/policies/classroom_change_request_error_mapper.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/widgets/request_notes_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ClassroomChangeRequestAction extends StatefulWidget {
  const ClassroomChangeRequestAction({
    super.key,
    required this.classroomId,
    this.classroomSubjectId,
    this.classroomSubjectAmbiguous = false,
    required this.role,
  });
  final String classroomId;
  final String? classroomSubjectId;
  final bool classroomSubjectAmbiguous;
  final UserRole role;

  @override
  State<ClassroomChangeRequestAction> createState() => _ActionState();
}

class _ActionState extends State<ClassroomChangeRequestAction> {
  bool _loading = false;
  bool _submitted = false;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: widget.role == UserRole.student
        ? S.of(context).requestTeacherChangeOrCancellation
        : S.of(context).requestTeacherWithdrawal,
    onPressed: _loading || _submitted ? null : _submit,
    icon: _loading
        ? const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : const Icon(Icons.person_off_outlined, color: Colors.white),
  );

  Future<void> _submit() async {
    final s = S.of(context);
    final classroomSubjectId = widget.classroomSubjectId?.trim() ?? '';
    if (widget.role == UserRole.teacher &&
        (classroomSubjectId.isEmpty || widget.classroomSubjectAmbiguous)) {
      debugPrint(
        'Teacher withdrawal blocked: classroom subject is missing or ambiguous',
      );
      showCustomSnackBar(context, s.gulfClassroomSubjectUnavailable, false);
      return;
    }
    if (widget.role == UserRole.student && classroomSubjectId.isEmpty) {
      debugPrint(
        'Classroom change request blocked: classroomSubjectId is missing',
      );
      showCustomSnackBar(context, s.gulfClassroomSubjectUnavailable, false);
      return;
    }
    final request = await showDialog<RequestNotesResult>(
      context: context,
      builder: (_) => RequestNotesDialog(
        title: widget.role == UserRole.student
            ? s.requestTeacherChangeOrCancellation
            : s.requestTeacherWithdrawal,
        label: s.cancellationReason,
        requestTypes: widget.role == UserRole.student
            ? const ['change_teacher', 'cancel_subject']
            : null,
      ),
    );
    if (request == null || !mounted) return;
    setState(() => _loading = true);
    final repo = getIt<ClassroomChangeRequestsRepo>();
    final result = widget.role == UserRole.student
        ? await repo.submitStudent(
            classroomId: widget.classroomId,
            classroomSubjectId: classroomSubjectId,
            notes: request.notes,
            requestType: request.requestType ?? 'change_teacher',
          )
        : await repo.submitTeacher(
            classroomId: widget.classroomId,
            classroomSubjectId: classroomSubjectId,
            notes: request.notes,
          );
    if (!mounted) return;
    setState(() {
      _loading = false;
      if (result.isRight() && widget.role == UserRole.student) {
        _submitted = true;
      }
    });
    result.fold(
      (failure) => showCustomSnackBar(
        context,
        mapClassroomChangeRequestFailure(failure),
        false,
      ),
      (_) => showCustomSnackBar(context, s.changeRequestSubmitted, true),
    );
  }
}
