import 'dart:io';

import 'package:bnan_app/core/helper/file_picker_helper.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_file_picker_field.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_lookup_selection.dart';
import 'package:bnan_app/features/academic_lookups/presentation/widgets/academic_lookup_dropdowns.dart';
import 'package:bnan_app/features/tables_management/presentation/manager/create_egyptian_schedule_cubit/create_egyptian_schedule_cubit.dart';
import 'package:bnan_app/features/tables_management/presentation/manager/create_egyptian_schedule_cubit/create_egyptian_schedule_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTableScheduleDialog extends StatefulWidget {
  const AddTableScheduleDialog({super.key});

  @override
  State<AddTableScheduleDialog> createState() => _AddTableScheduleDialogState();
}

class _AddTableScheduleDialogState extends State<AddTableScheduleDialog> {
  AcademicLookupSelection selection = const AcademicLookupSelection();
  File? scheduleImage;
  String? validationMessage;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      CreateEgyptianScheduleCubit,
      CreateEgyptianScheduleState
    >(
      listener: (context, state) {
        if (state is CreateEgyptianScheduleSuccess) {
          Navigator.pop(context, true);
        }

        if (state is CreateEgyptianScheduleFailure) {
          showCustomSnackBar(context, state.message, false);
        }
      },
      builder: (context, state) {
        return CustomAppDialog(
          child: SingleChildScrollView(
            padding: const EdgeInsetsDirectional.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomDialogHeader(
                  title: S.of(context).classSchedulesManagement,
                ),
                const SizedBox(height: 16),
                AcademicLookupDropdowns(
                  showCurriculum: true,
                  showGrade: true,
                  showClassroom: true,
                  showSubject: false,
                  onSelectionChanged: _onSelectionChanged,
                ),
                const SizedBox(height: 16),
                CustomFilePickerField(
                  label: S.of(context).chooseScheduleImage,
                  hint: _fileName ?? S.of(context).selectFile,
                  hasFile: scheduleImage != null,
                  onTap: _pickImage,
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
                  text: S.of(context).uploadSchedule,
                  isLoading: state is CreateEgyptianScheduleLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? get _fileName {
    final path = scheduleImage?.path;
    if (path == null || path.isEmpty) return null;
    return path.split(RegExp(r'[\\/]')).last;
  }

  void _onSelectionChanged(AcademicLookupSelection value) {
    setState(() {
      selection = value;
      validationMessage = null;
    });
  }

  Future<void> _pickImage() async {
    final file = await FilePickerHelper.pickFile(
      allowedExtensions: const ['jpg', 'jpeg', 'png'],
    );
    if (file == null) return;

    setState(() {
      scheduleImage = file;
      validationMessage = null;
    });
  }

  void _submit() {
    final classroomId = selection.classroomId;
    final image = scheduleImage;

    if (selection.curriculumId == null || selection.gradeId == null) {
      setState(() => validationMessage = S.current.fillAllRequiredFields);
      return;
    }

    if (classroomId == null || classroomId.isEmpty) {
      setState(() => validationMessage = S.current.classroomRequired);
      return;
    }

    if (image == null) {
      setState(() => validationMessage = S.current.scheduleImageRequired);
      return;
    }

    context.read<CreateEgyptianScheduleCubit>().createEgyptianSchedule(
      classroomId: classroomId,
      scheduleImage: image,
    );
  }
}
