import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_lookup_selection.dart';
import 'package:bnan_app/features/academic_lookups/data/repo/academic_lookups_repo.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_request_model.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_actions_cubit/classroom_actions_cubit.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_actions_cubit/classroom_actions_state.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/add_classroom_form_fields.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/shared_classroom_creator.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/shared_classroom_form_state.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/shared_classroom_loader.dart';
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
  final nameController = TextEditingController();
  final meetingLinkController = TextEditingController();
  AcademicLookupSelection selection = const AcademicLookupSelection();
  SharedClassroomFormState sharedState = const SharedClassroomFormState();
  bool isShared = false;
  String? supervisorId, validationMessage;

  @override
  void dispose() {
    nameController.dispose();
    meetingLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocConsumer<ClassroomActionsCubit, ClassroomActionsState>(
      listener: (context, state) {
        if (state is CreateClassroomSuccess) Navigator.pop(context, true);
        if (state is CreateClassroomFailure) setState(() => validationMessage = state.message);
      },
      builder: (context, state) => CustomAppDialog(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsetsDirectional.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomDialogHeader(title: isShared ? s.sharedClassroom : s.addNewChapter),
                const SizedBox(height: 16),
                AddClassroomFormFields(
                  isShared: isShared,
                  nameController: nameController,
                  meetingLinkController: meetingLinkController,
                  sharedState: sharedState,
                  supervisorId: supervisorId,
                  onKindChanged: _toggleKind,
                  onStandardSelectionChanged: (v) => setState(() => selection = v),
                  onSupervisorChanged: (v) => setState(() => supervisorId = v),
                  onGrade1Changed: (v) => _changeGrade(g1: v),
                  onGrade2Changed: (v) => _changeGrade(g2: v),
                  onPrimaryChanged: (v) => setState(() => sharedState = sharedState.copyWith(primaryTargetIndex: v)),
                  onToggleSubject: _toggleSubject,
                ),
                if (validationMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(validationMessage!, style: StylesManager.styleRegular12(context).copyWith(color: Colors.red)),
                ],
                const SizedBox(height: 16),
                CustomAppButton(text: s.save, isLoading: state is CreateClassroomLoading, onPressed: submit),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleKind(bool shared) async {
    setState(() => isShared = shared);
    if (shared && sharedState.curriculumId == null) {
      final curriculums = context.read<AcademicLookupsCubit>().state.curriculums;
      final init = await initSharedClassroomState(getIt<AcademicLookupsRepo>(), curriculums);
      if (mounted) setState(() => sharedState = init);
    }
  }

  void _changeGrade({String? g1, String? g2}) async {
    setState(() => sharedState = sharedState.copyWith(loadingSubjects: true));
    final updated = await updateSharedGradeSubjects(getIt<AcademicLookupsRepo>(), sharedState, grade1Id: g1, grade2Id: g2);
    if (mounted) setState(() => sharedState = updated);
  }

  void _toggleSubject(String id) {
    final next = Set<String>.from(sharedState.selectedSubjectIds);
    next.contains(id) ? next.remove(id) : next.add(id);
    setState(() => sharedState = sharedState.copyWith(selectedSubjectIds: next));
  }

  void submit() {
    if (!(formKey.currentState?.validate() ?? false)) return;
    final name = nameController.text.trim();
    if (isShared) {
      final req = buildSharedClassroomRequest(name: name, state: sharedState, supervisorId: supervisorId, onError: (e) => setState(() => validationMessage = e));
      if (req != null) context.read<ClassroomActionsCubit>().createClassroom(req);
    } else {
      if (selection.curriculumId == null || selection.gradeId == null || supervisorId == null) {
        setState(() => validationMessage = S.current.fillAllRequiredFields);
        return;
      }
      final link = meetingLinkController.text.trim();
      context.read<ClassroomActionsCubit>().createClassroom(
        ClassroomRequestModel(
          name: name,
          curriculumId: selection.curriculumId,
          gradeId: selection.gradeId,
          supervisorId: supervisorId,
          meetingLink: link.isEmpty ? null : link,
        ),
      );
    }
  }
}
