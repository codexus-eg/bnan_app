import 'dart:io';

import 'package:bnan_app/core/helper/file_picker_helper.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/create_assignment_request_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/create_assignment/create_assignment_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateAssignmentCubit extends Cubit<CreateAssignmentState> {
  CreateAssignmentCubit(this.assignmentsRepo)
    : super(CreateAssignmentInitial());

  final AssignmentsRepo assignmentsRepo;

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final totalPointsController = TextEditingController(text: '10');

  String? selectedCurriculumId;
  String? selectedClassroomSubjectId;
  String? selectedGradeId;
  String? selectedDueDate;
  File? attachmentFile;
  String? selectedClassroomId;
  String? selectedSubjectId;
  String? validationMessage;
  void changeClassroom(String? value) {
    selectedClassroomId = value;
    selectedSubjectId = null;
    selectedClassroomSubjectId = null;
    emit(CreateAssignmentChangeValue());
  }

  void changeClassroomSubject({
    required String? subjectId,
    required String? classroomSubjectId,
  }) {
    selectedSubjectId = subjectId;
    selectedClassroomSubjectId = classroomSubjectId;
    emit(CreateAssignmentChangeValue());
  }

  String? get attachmentFileName {
    if (attachmentFile == null) return null;
    return attachmentFile!.path.split('/').last;
  }

  Future<void> pickAttachment() async {
    attachmentFile = await FilePickerHelper.pickFile();

    if (attachmentFile == null) return;

    emit(CreateAssignmentChangeValue());
  }

  void changeCurriculum(String? value) {
    selectedCurriculumId = value;
    selectedGradeId = null;
    emit(CreateAssignmentChangeValue());
  }

  void changeGrade(String? value) {
    selectedGradeId = value;
    emit(CreateAssignmentChangeValue());
  }

  void changeDueDate(String? value) {
    selectedDueDate = value;
    emit(CreateAssignmentChangeValue());
  }

  Future<void> createAssignment() async {
    validationMessage = null;

    if (!formKey.currentState!.validate()) return;

    if (selectedClassroomId == null ||
        selectedSubjectId == null ||
        selectedDueDate == null) {
      validationMessage = S.current.fillAllRequiredFields;
      emit(CreateAssignmentChangeValue());
      return;
    }

    emit(CreateAssignmentLoading());

    final request = CreateAssignmentRequestModel(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      dueDate: selectedDueDate!,
      classroom: selectedClassroomId!,
      subject: selectedSubjectId!,
      attachment: attachmentFile,
    );

    final result = await assignmentsRepo.createAssignment(request: request);

    result.fold(
      (failure) {
        emit(
          CreateAssignmentFailure(
            errorMessage: S.current.fillAllRequiredFields,
          ),
        );
      },
      (assignment) {
        emit(CreateAssignmentSuccess(assignment: assignment));
      },
    );
  }

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    totalPointsController.dispose();
    return super.close();
  }
}
