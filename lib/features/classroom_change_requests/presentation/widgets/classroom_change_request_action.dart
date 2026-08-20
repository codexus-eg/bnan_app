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
    required this.role,
  });
  final String classroomId;
  final String? classroomSubjectId;
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
    if (widget.role == UserRole.student && classroomSubjectId.isEmpty) {
      showCustomSnackBar(context, s.unexpectedError, false);
      return;
    }
    final notes = await showDialog<String>(
      context: context,
      builder: (_) => RequestNotesDialog(
        title: widget.role == UserRole.student
            ? s.requestTeacherChangeOrCancellation
            : s.requestTeacherWithdrawal,
        label: s.cancellationReason,
      ),
    );
    if (notes == null || !mounted) return;
    setState(() => _loading = true);
    final repo = getIt<ClassroomChangeRequestsRepo>();
    final result = widget.role == UserRole.student
        ? await repo.submitStudent(
            classroomId: widget.classroomId,
            classroomSubjectId: classroomSubjectId,
            notes: notes,
          )
        : await repo.submitTeacher(
            classroomId: widget.classroomId,
            notes: notes,
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
