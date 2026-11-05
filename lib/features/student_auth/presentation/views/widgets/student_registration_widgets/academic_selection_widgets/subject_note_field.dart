import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubjectNoteField extends StatefulWidget {
  const SubjectNoteField({super.key, required this.subjectId, required this.subjectName});
  final String subjectId, subjectName;

  @override
  State<SubjectNoteField> createState() => _SubjectNoteFieldState();
}

class _SubjectNoteFieldState extends State<SubjectNoteField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<RegisterCubit>().subjectNotes[widget.subjectId] ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CustomTextField(
        controller: _controller,
        label: s.subjectItemNotesLabel(widget.subjectName),
        hintText: s.subjectRequestNotesHint,
        maxLine: 3,
        inputFormatters: [LengthLimitingTextInputFormatter(2000)],
        onChanged: (text) => context.read<RegisterCubit>().updateSubjectNote(widget.subjectId, text),
      ),
    );
  }
}
