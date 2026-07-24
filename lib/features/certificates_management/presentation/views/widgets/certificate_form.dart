import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_lookup_selection.dart';
import 'package:bnan_app/features/academic_lookups/presentation/widgets/academic_lookup_dropdowns.dart';
import 'package:bnan_app/features/certificates_management/data/models/requests/certificate_subject_request_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/requests/create_monthly_certificate_request_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/requests/update_monthly_certificate_request_model.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/create_monthly_certificate_cubit/create_monthly_certificate_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/create_monthly_certificate_cubit/create_monthly_certificate_state.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_classroom_students_cubit/get_classroom_students_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_student_subjects_cubit/get_student_subjects_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/update_monthly_certificate_cubit/update_monthly_certificate_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/update_monthly_certificate_cubit/update_monthly_certificate_state.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/certificate_student_dropdown.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/certificate_subjects_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CertificateForm extends StatefulWidget {
  const CertificateForm({super.key, required this.title, this.certificateId});

  final String title;
  final String? certificateId;

  bool get isEdit => certificateId?.trim().isNotEmpty == true;

  @override
  State<CertificateForm> createState() => _CertificateFormState();
}

class _CertificateFormState extends State<CertificateForm> {
  String? classroomId;
  String? selectedStudentId;

  List<CertificateSubjectRequestModel> subjectRequests = [];

  void onAcademicSelectionChanged(AcademicLookupSelection selection) {
    final newClassroomId = selection.classroomId?.trim();

    if (newClassroomId == classroomId) return;

    setState(() {
      classroomId = newClassroomId;
      selectedStudentId = null;
      subjectRequests = [];
    });

    context.read<GetClassroomStudentsCubit>().reset();
    context.read<GetStudentSubjectsCubit>().reset();

    if (newClassroomId?.isNotEmpty != true) return;

    context.read<GetClassroomStudentsCubit>().getClassroomStudents(
      classroomId: newClassroomId!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return blocListner(context, widget.isEdit);
  }

  BlocListener blocListner(BuildContext context, bool isEdit) {
    if (isEdit == false) {
      return BlocListener<
        CreateMonthlyCertificateCubit,
        CreateMonthlyCertificateState
      >(listener: _createCertificateListener, child: body(context));
    } else {
      return BlocListener<
        UpdateMonthlyCertificateCubit,
        UpdateMonthlyCertificateState
      >(listener: _updateCertificateListener, child: body(context));
    }
  }

  Column body(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDialogHeader(title: widget.title),
        const SizedBox(height: 16),
        AcademicLookupDropdowns(
          showCurriculum: true,
          showGrade: true,
          showClassroom: true,
          showSubject: false,
          onSelectionChanged: onAcademicSelectionChanged,
        ),
        const SizedBox(height: 16),
        CertificateStudentDropdown(
          classroomId: classroomId,
          onStudentSelected: _onStudentSelected,
        ),
        const SizedBox(height: 16),
        Text(
          S.of(context).subjectsGrades,
          style: StylesManager.styleBold14(
            context,
          ).copyWith(color: ColorManager.mainColor14),
        ),
        const SizedBox(height: 8),
        CertificateSubjectsSection(
          onChanged: (subjects) {
            subjectRequests = subjects;
          },
        ),
        const SizedBox(height: 16),
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildSaveButton() {
    if (widget.isEdit == true) {
      return BlocBuilder<
        UpdateMonthlyCertificateCubit,
        UpdateMonthlyCertificateState
      >(
        builder: (context, state) {
          final isLoading = state is UpdateMonthlyCertificateLoading;

          return CustomAppButton(
            text: S.of(context).save,
            onPressed: isLoading ? () {} : _saveCertificate,
          );
        },
      );
    }

    return BlocBuilder<
      CreateMonthlyCertificateCubit,
      CreateMonthlyCertificateState
    >(
      builder: (context, state) {
        final isLoading = state is CreateMonthlyCertificateLoading;

        return CustomAppButton(
          text: S.of(context).save,
          onPressed: isLoading ? () {} : _saveCertificate,
        );
      },
    );
  }

  void _onStudentSelected(String? studentId) {
    selectedStudentId = studentId;
    subjectRequests = [];
  }

  void _saveCertificate() {
    final studentId = selectedStudentId?.trim();

    if (studentId == null || studentId.isEmpty) {
      showCustomSnackBar(context, S.of(context).pleaseSelectStudent, false);
      return;
    }

    if (subjectRequests.isEmpty) {
      showCustomSnackBar(
        context,
        S.of(context).pleaseEnterSubjectsGrades,
        false,
      );
      return;
    }

    if (widget.isEdit) {
      final request = UpdateMonthlyCertificateRequestModel(
        subjects: subjectRequests,
      );

      _updateCertificate(request);
      return;
    }

    final request = CreateMonthlyCertificateRequestModel(
      studentId: studentId,
      subjects: subjectRequests,
    );

    _createCertificate(request);
  }

  void _createCertificate(CreateMonthlyCertificateRequestModel request) {
    context.read<CreateMonthlyCertificateCubit>().createMonthlyCertificate(
      request: request,
    );
  }

  void _updateCertificate(UpdateMonthlyCertificateRequestModel request) {
    context.read<UpdateMonthlyCertificateCubit>().updateMonthlyCertificate(
      certificateId: widget.certificateId!.trim(),
      request: request,
    );
  }

  void _createCertificateListener(
    BuildContext context,
    CreateMonthlyCertificateState state,
  ) {
    if (state is CreateMonthlyCertificateSuccess) {
      Navigator.pop(context);

      showCustomSnackBar(
        context,
        S.of(context).certificateAddedSuccessfully,
        true,
      );
    }

    if (state is CreateMonthlyCertificateFailure) {
      showCustomSnackBar(context, state.message, false);
    }
  }

  void _updateCertificateListener(
    BuildContext context,
    UpdateMonthlyCertificateState state,
  ) {
    if (state is UpdateMonthlyCertificateSuccess) {
      Navigator.pop(context);

      showCustomSnackBar(
        context,
        S.of(context).certificateUpdatedSuccessfully,
        true,
      );
    }

    if (state is UpdateMonthlyCertificateFailure) {
      showCustomSnackBar(context, state.message, false);
    }
  }
}
