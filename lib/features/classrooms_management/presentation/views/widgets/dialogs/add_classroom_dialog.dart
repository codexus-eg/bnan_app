import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_lookup_selection.dart';
import 'package:bnan_app/features/academic_lookups/presentation/widgets/academic_lookup_dropdowns.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_request_model.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_actions_cubit/classroom_actions_cubit.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_actions_cubit/classroom_actions_state.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/add_classroom_supervisor_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddClassroomDialog extends StatefulWidget {
  const AddClassroomDialog({super.key});

  @override
  State<AddClassroomDialog> createState() => AddClassroomDialogState();
}

class AddClassroomDialogState extends State<AddClassroomDialog> {
  final formKey = GlobalKey<FormState>();
  final classNameController = TextEditingController();
  final meetingLinkController = TextEditingController();
  AcademicLookupSelection selection = const AcademicLookupSelection();
  String? supervisorId;
  String? validationMessage;

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
        if (state is CreateClassroomSuccess) Navigator.pop(context, true);
        if (state is CreateClassroomFailure) {
          setState(() => validationMessage = state.message);
        }
      },
      builder: (context, state) {
        return CustomAppDialog(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsetsDirectional.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomDialogHeader(title: s.addNewChapter),
                  const SizedBox(height: 16),
                  CustomTextField(
                    hintStyle: getStyle(context),
                    label: s.className,
                    labelColor: ColorManager.mainColor14,
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
                  const SizedBox(height: 16),
                  AcademicLookupDropdowns(
                    showCurriculum: true,
                    showGrade: true,
                    showClassroom: false,
                    showSubject: false,
                    onSelectionChanged: (value) {
                      setState(() {
                        selection = value;
                        validationMessage = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  AddClassroomSupervisorField(
                    value: supervisorId,
                    onChanged: (value) => setState(() {
                      supervisorId = value;
                      validationMessage = null;
                    }),
                  ),
                  if (validationMessage != null) ...[
                    const SizedBox(height: 16),
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
                    isLoading: state is CreateClassroomLoading,
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

    if (selection.curriculumId == null ||
        selection.gradeId == null ||
        supervisorId == null) {
      setState(() => validationMessage = S.current.fillAllRequiredFields);
      return;
    }

    context.read<ClassroomActionsCubit>().createClassroom(
      ClassroomRequestModel(
        name: classNameController.text.trim(),
        curriculumId: selection.curriculumId,
        gradeId: selection.gradeId,
        supervisorId: supervisorId,
        meetingLink: meetingLinkController.text.trim().isEmpty
            ? null
            : meetingLinkController.text.trim(),
      ),
    );
  }

  TextStyle getStyle(BuildContext context) {
    return StylesManager.styleRegular16(
      context,
    ).copyWith(color: ColorManager.mainColor14);
  }
}
