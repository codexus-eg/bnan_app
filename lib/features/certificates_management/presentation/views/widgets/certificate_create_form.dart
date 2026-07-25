import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_lookup_selection.dart';
import 'package:bnan_app/features/academic_lookups/presentation/widgets/academic_lookup_dropdowns.dart';
import 'package:bnan_app/features/certificates_management/data/models/requests/certificate_subject_request_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/requests/create_monthly_certificate_request_model.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/create_monthly_certificate_cubit/create_monthly_certificate_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/create_monthly_certificate_cubit/create_monthly_certificate_state.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_classroom_students_cubit/get_classroom_students_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_monthly_certificates_cubit/get_monthly_certificates_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_student_subjects_cubit/get_student_subjects_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/certificate_student_dropdown.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/certificate_subjects_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CertificateCreateForm extends StatefulWidget {
  const CertificateCreateForm({super.key, required this.title});

  final String title;

  @override
  State<CertificateCreateForm> createState() => _CertificateCreateFormState();
}

class _CertificateCreateFormState extends State<CertificateCreateForm> {
  String? classroomId;
  String? selectedStudentId;
  String? formError;

  List<CertificateSubjectRequestModel> subjectRequests = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      CreateMonthlyCertificateCubit,
      CreateMonthlyCertificateState
    >(listener: _listener, child: _buildBody());
  }

  Widget _buildBody() {
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
          onSelectionChanged: _onAcademicSelectionChanged,
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
        CertificateSubjectsSection(onChanged: _onSubjectsChanged),
        const SizedBox(height: 16),
        if (formError != null) ...[_buildError(), const SizedBox(height: 8)],
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildError() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        formError!,
        style: StylesManager.styleRegular14(
          context,
        ).copyWith(color: Colors.red),
      ),
    );
  }

  Widget _buildSaveButton() {
    return BlocBuilder<
      CreateMonthlyCertificateCubit,
      CreateMonthlyCertificateState
    >(
      builder: (context, state) {
        return CustomAppButton(
          text: S.of(context).save,
          isLoading: state is CreateMonthlyCertificateLoading,
          onPressed: _save,
        );
      },
    );
  }

  void _onAcademicSelectionChanged(AcademicLookupSelection selection) {
    final newClassroomId = selection.classroomId?.trim();

    if (newClassroomId == classroomId) return;

    setState(() {
      classroomId = newClassroomId;
      selectedStudentId = null;
      subjectRequests = [];
      formError = null;
    });

    context.read<GetClassroomStudentsCubit>().reset();
    context.read<GetStudentSubjectsCubit>().reset();

    if (newClassroomId?.isNotEmpty != true) return;

    context.read<GetClassroomStudentsCubit>().getClassroomStudents(
      classroomId: newClassroomId!,
    );
  }

  void _onStudentSelected(String? studentId) {
    setState(() {
      selectedStudentId = studentId;
      subjectRequests = [];
      formError = null;
    });
  }

  void _onSubjectsChanged(List<CertificateSubjectRequestModel> subjects) {
    subjectRequests = subjects;

    if (formError != null) {
      setState(() => formError = null);
    }
  }

  void _save() {
    final studentId = selectedStudentId?.trim();

    if (studentId == null || studentId.isEmpty) {
      _setError(S.of(context).pleaseSelectStudent);
      return;
    }

    if (subjectRequests.isEmpty) {
      _setError(S.of(context).pleaseEnterSubjectsGrades);
      return;
    }

    context.read<CreateMonthlyCertificateCubit>().createMonthlyCertificate(
      request: CreateMonthlyCertificateRequestModel(
        studentId: studentId,
        subjects: subjectRequests,
      ),
    );
  }

  void _listener(BuildContext context, CreateMonthlyCertificateState state) {
    if (state is CreateMonthlyCertificateSuccess) {
      context.read<GetMonthlyCertificatesCubit>().getMonthlyCertificates();

      Navigator.pop(context);

      showCustomSnackBar(
        context,
        S.of(context).certificateAddedSuccessfully,
        true,
      );
      return;
    }

    if (state is CreateMonthlyCertificateFailure) {
      _setError(state.message);
    }
  }

  void _setError(String message) {
    if (!mounted) return;

    setState(() {
      formError = message;
    });
  }
}
