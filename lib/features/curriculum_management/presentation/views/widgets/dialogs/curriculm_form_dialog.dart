import 'dart:io';

import 'package:bnan_app/core/helper/file_picker_helper.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/curriculum_management/data/models/create_curriculum_request_model.dart';
import 'package:bnan_app/features/curriculum_management/data/models/curriculum_model.dart';
import 'package:bnan_app/features/curriculum_management/data/models/update_curriculum_request_model.dart';
import 'package:bnan_app/features/curriculum_management/presentation/manager/curriculum_actions_cubit/curriculum_actions_cubit.dart';
import 'package:bnan_app/features/curriculum_management/presentation/manager/curriculum_actions_cubit/curriculum_actions_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurriculumFormDialog extends StatefulWidget {
  const CurriculumFormDialog({super.key, this.curriculum});

  final CurriculumModel? curriculum;

  bool get isEdit => curriculum != null;

  @override
  State<CurriculumFormDialog> createState() => _CurriculumFormDialogState();
}

class _CurriculumFormDialogState extends State<CurriculumFormDialog> {
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;

  String? selectedRegistrationMode;
  File? selectedIcon;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.curriculum?.name ?? '');

    descriptionController = TextEditingController(
      text: widget.curriculum?.description ?? '',
    );

    selectedRegistrationMode = widget.curriculum?.registrationMode;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return CustomAppDialog(
      child: BlocConsumer<CurriculumActionsCubit, CurriculumActionsState>(
        listener: (context, state) {
          if (state is CreateCurriculumSuccess ||
              state is UpdateCurriculumSuccess) {
            Navigator.pop(context, true);
          }

          if (state is CreateCurriculumFailure) {
            setState(() {
              errorMessage = state.message;
            });
          }

          if (state is UpdateCurriculumFailure) {
            setState(() {
              errorMessage = state.message;
            });
          }
        },
        builder: (context, state) {
          final isLoading =
              state is CreateCurriculumLoading ||
              state is UpdateCurriculumLoading;

          return Padding(
            padding: const EdgeInsetsDirectional.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomDialogHeader(
                  title: widget.isEdit ? s.editCurriculum : s.addNewCurriculum,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: s.curriculumName,
                  controller: nameController,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: s.curriculumDescription,
                  controller: descriptionController,
                ),
                if (!widget.isEdit) ...[
                  const SizedBox(height: 16),
                  CustomDropdown(
                    label: s.registrationMode,
                    hint: s.chooseCurriculumType,
                    value: selectedRegistrationMode,
                    items: const ['gulf', 'egyptian'],
                    itemsLabels: {
                      'gulf': s.gulfCurriculum,
                      'egyptian': s.egyptianCurriculum,
                    },
                    onChanged: (value) {
                      setState(() {
                        selectedRegistrationMode = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    readOnly: true,
                    hintText: selectedIcon == null
                        ? s.chooseFile
                        : selectedIcon!.path.split(Platform.pathSeparator).last,
                    label: s.chooseCurriculumIcon,
                    backgroundColor: Colors.transparent,
                    onTap: isLoading ? null : _pickIcon,
                  ),
                ],
                const SizedBox(height: 24),
                if (errorMessage != null) ...[
                  Text(
                    errorMessage!,
                    style: StylesManager.styleRegular12(
                      context,
                    ).copyWith(color: ColorManager.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                ],
                CustomAppButton(
                  text: s.save,
                  isLoading: isLoading,
                  onPressed: widget.isEdit
                      ? _updateCurriculum
                      : _createCurriculum,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickIcon() async {
    final file = await FilePickerHelper.pickFile(
      allowedExtensions: const ['jpg', 'jpeg', 'png'],
    );

    if (file == null || !mounted) return;

    setState(() {
      selectedIcon = file;
    });
  }

  void _createCurriculum() {
    setState(() {
      errorMessage = null;
    });

    final name = nameController.text.trim();
    final description = descriptionController.text.trim();

    if (name.isEmpty ||
        description.isEmpty ||
        selectedRegistrationMode == null ||
        selectedIcon == null) {
      setState(() {
        errorMessage = S.of(context).fillAllRequiredFields;
      });
      return;
    }

    final request = CreateCurriculumRequestModel(
      name: name,
      description: description,
      registrationMode: selectedRegistrationMode!,
      icon: selectedIcon!,
    );

    context.read<CurriculumActionsCubit>().createCurriculum(request);
  }

  void _updateCurriculum() {
    setState(() {
      errorMessage = null;
    });

    final name = nameController.text.trim();
    final description = descriptionController.text.trim();

    if (name.isEmpty || description.isEmpty) {
      setState(() {
        errorMessage = S.of(context).fillAllRequiredFields;
      });
      return;
    }

    final request = UpdateCurriculumRequestModel(
      name: name,
      description: description,
    );

    context.read<CurriculumActionsCubit>().updateCurriculum(
      curriculumId: widget.curriculum!.id,
      request: request,
    );
  }
}
