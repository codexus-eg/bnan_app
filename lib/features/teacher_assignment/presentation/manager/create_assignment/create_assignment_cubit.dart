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
    _emitChange();
  }

  void changeClassroomSubject({
    required String? subjectId,
    required String? classroomSubjectId,
  }) {
    selectedSubjectId = subjectId;
    selectedClassroomSubjectId = classroomSubjectId;
    _emitChange();
  }

  String? get attachmentFileName {
    if (attachmentFile == null) return null;
    return attachmentFile!.path.split('/').last;
  }

  Future<void> pickAttachment() async {
    final file = await FilePickerHelper.pickFile();
    if (isClosed || file == null) return;

    attachmentFile = file;
    _emitChange();
  }

  void changeCurriculum(String? value) {
    selectedCurriculumId = value;
    selectedGradeId = null;
    _emitChange();
  }

  void changeGrade(String? value) {
    selectedGradeId = value;
    _emitChange();
  }

  void changeDueDate(String? value) {
    selectedDueDate = value;
    _emitChange();
  }

  Future<void> createAssignment() async {
    if (isClosed) return;
    clearError();

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
    if (isClosed) return;

    result.fold(
      (failure) {
        emit(CreateAssignmentFailure(errorMessage: failure.message));
      },
      (assignment) {
        emit(CreateAssignmentSuccess(assignment: assignment));
      },
    );
  }

  void clearError() {
    if (validationMessage == null && state is! CreateAssignmentFailure) return;
    _emitChange();
  }

  void _emitChange() {
    validationMessage = null;
    if (!isClosed) emit(CreateAssignmentChangeValue());
  }

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    totalPointsController.dispose();
    return super.close();
  }
}
