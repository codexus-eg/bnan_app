import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_model.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_request_model.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_actions_cubit/classroom_actions_cubit.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_actions_cubit/classroom_actions_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditClassroomDialog extends StatefulWidget {
  const EditClassroomDialog({super.key, required this.classroomItem});
  final ClassroomModel classroomItem;

  @override
  State<EditClassroomDialog> createState() => EditClassroomDialogState();
}

class EditClassroomDialogState extends State<EditClassroomDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController classNameController;
  late final TextEditingController meetingLinkController;
  String? validationMessage;

  @override
  void initState() {
    super.initState();
    classNameController = TextEditingController(
      text: widget.classroomItem.name,
    );
    meetingLinkController = TextEditingController(
      text: widget.classroomItem.meetingLink,
    );
  }

  @override
  void dispose() {
    classNameController.dispose();
    meetingLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocConsumer<ClassroomActionsCubit, ClassroomActionsState>(
      listener: (context, state) {
        if (state is UpdateClassroomSuccess) Navigator.pop(context, true);
        if (state is UpdateClassroomFailure) {
          setState(() => validationMessage = state.message);
        }
      },
      builder: (context, state) {
        return CustomAppDialog(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomDialogHeader(title: s.editClass),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: s.className,
                    hintStyle: StylesManager.styleRegular16(
                      context,
                    ).copyWith(color: ColorManager.mainColor14),
                    controller: classNameController,
                    backgroundColor: ColorManager.white,
                    validator: (value) => value?.trim().isEmpty ?? true
                        ? s.classNameRequired
                        : null,
                    onChanged: (_) => setState(() => validationMessage = null),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: s.meetingLinkOptional,
                    controller: meetingLinkController,
                    keyboardType: TextInputType.url,
                    backgroundColor: ColorManager.white,
                    onChanged: (_) => setState(() => validationMessage = null),
                  ),
                  if (validationMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      validationMessage!,
                      style: StylesManager.styleRegular12(
                        context,
                      ).copyWith(color: Colors.red),
                    ),
                  ],
                  const SizedBox(height: 16),
                  CustomAppButton(
                    text: s.save,
                    isLoading: state is UpdateClassroomLoading,
                    onPressed: submit,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void submit() {
    if (!(formKey.currentState?.validate() ?? false)) return;

    context.read<ClassroomActionsCubit>().updateClassroom(
      widget.classroomItem.id,
      ClassroomRequestModel(
        name: classNameController.text.trim(),
        meetingLink: meetingLinkController.text.trim(),
      ),
    );
  }
}
