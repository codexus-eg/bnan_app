import 'package:bnan_app/features/teacher_request_groups/presentation/views/dialogs/accept_registration_request_content.dart';
import 'package:flutter/material.dart';

class AcceptRegistrationRequestDialog extends StatefulWidget {
  const AcceptRegistrationRequestDialog({
    super.key,
    required this.studentName,
    this.onAccept,
  });
  final String studentName;
  final Future<void> Function()? onAccept;

  @override
  State<AcceptRegistrationRequestDialog> createState() =>
      _AcceptRegistrationRequestDialogState();
}

class _AcceptRegistrationRequestDialogState
    extends State<AcceptRegistrationRequestDialog> {
  bool loading = false;

  Future<void> _accept() async {
    if (loading || widget.onAccept == null) return;
    setState(() => loading = true);
    await widget.onAccept!();
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) => AcceptRegistrationRequestContent(
    studentName: widget.studentName,
    loading: loading,
    onAccept: _accept,
  );
}
