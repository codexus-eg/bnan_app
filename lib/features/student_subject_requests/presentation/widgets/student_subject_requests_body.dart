import 'package:bnan_app/core/constants/tamara_default_address.dart';
import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/features/payments/data/models/tamara_checkout_request.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/subject_request_payloads.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/manager/student_subject_requests_cubit.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/manager/student_subject_requests_state.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/manager/subject_request_payment_cubit.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/manager/subject_request_payment_state.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/widgets/subject_request_subjects_section.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/widgets/subject_request_package_dialog.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/widgets/subject_request_package_selector.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentSubjectRequestsBody extends StatefulWidget {
  const StudentSubjectRequestsBody({super.key});
  @override
  State<StudentSubjectRequestsBody> createState() =>
      _StudentSubjectRequestsBodyState();
}

class _StudentSubjectRequestsBodyState
    extends State<StudentSubjectRequestsBody> {
  String discountCode = '';

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<StudentSubjectRequestsCubit, StudentSubjectRequestsState>(
        builder: _buildState,
      );

  Widget _buildState(BuildContext context, StudentSubjectRequestsState state) {
    if (state.availability == null) return const SizedBox.shrink();
    final cubit = context.read<StudentSubjectRequestsCubit>();
    final availability = state.availability!;
    final registrationMode = availability.registrationMode;
    return RefreshIndicator(
      onRefresh: () => cubit.load(refresh: true),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SubjectRequestSubjectsSection(
            subjects: availability.subjects,
            selectedId: state.selectedSubjectId,
            onSelected: cubit.selectSubject,
          ),
          SubjectRequestPackageSelector(
            selectedName: _selectedPackageName(state),
            hasPackages: state.packages.isNotEmpty,
            enabled: state.selectedSubjectId != null,
            onTap: () => _selectPackage(state),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: S.of(context).theRequiredLesson,
            hintText: S.of(context).studentNotesExample,
            maxLine: 4,
            inputFormatters: [LengthLimitingTextInputFormatter(2000)],
            onChanged: cubit.updateNotes,
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              S.of(context).subjectRequestNotesCounter(state.notes.length),
              textDirection: TextDirection.ltr,
            ),
          ),
          if (registrationMode == RegistrationMode.gulf) ...[
            const SizedBox(height: 16),
            CustomTextField(
              label: S.of(context).discountCode,
              onChanged: (value) => discountCode = value,
            ),
          ],
          const SizedBox(height: 20),
          _submitButton(state, registrationMode),
        ],
      ),
    );
  }

  Widget _submitButton(
    StudentSubjectRequestsState state,
    RegistrationMode registrationMode,
  ) => BlocBuilder<SubjectRequestPaymentCubit, SubjectRequestPaymentState>(
    builder: (context, payment) {
      if (payment.phase == SubjectRequestPaymentPhase.verificationTimeout) {
        return CustomAppButton(
          text: S.of(context).subjectRequestVerifyPayment,
          onPressed: context.read<SubjectRequestPaymentCubit>().verify,
        );
      }
      if (payment.phase == SubjectRequestPaymentPhase.terminalFailure) {
        return CustomAppButton(
          text: S.of(context).retry,
          onPressed: state.canSubmit
              ? () => _submit(state, registrationMode)
              : null,
        );
      }
      final loading =
          state.isSubmitting ||
          payment.phase == SubjectRequestPaymentPhase.creatingCheckout ||
          payment.phase == SubjectRequestPaymentPhase.openingTamara ||
          payment.phase == SubjectRequestPaymentPhase.verifying ||
          payment.phase == SubjectRequestPaymentPhase.completed;
      return CustomAppButton(
        text: S.of(context).confirmRequest,
        isLoading: loading,
        onPressed: state.canSubmit
            ? () => _submit(state, registrationMode)
            : null,
      );
    },
  );

  String? _selectedPackageName(StudentSubjectRequestsState state) {
    for (final item in state.packages) {
      if (item.id == state.selectedPackageId) return item.name;
    }
    return null;
  }

  Future<void> _selectPackage(StudentSubjectRequestsState state) async {
    final id = await SubjectRequestPackageDialog.show(
      context,
      packages: state.packages,
      selectedId: state.selectedPackageId,
      hidePrices:
          state.availability?.registrationMode == RegistrationMode.egyptian,
    );
    if (!mounted || id == null) return;
    context.read<StudentSubjectRequestsCubit>().selectPackage(id);
  }

  void _submit(
    StudentSubjectRequestsState state,
    RegistrationMode registrationMode,
  ) {
    if (registrationMode == RegistrationMode.egyptian) {
      context.read<StudentSubjectRequestsCubit>().submitEgyptian();
      return;
    }
    final cubit = context.read<StudentSubjectRequestsCubit>();
    if (!cubit.hasValidSelectedGulfPackage) {
      showCustomSnackBar(context, S.of(context).invalidPackage, false);
      return;
    }
    context.read<SubjectRequestPaymentCubit>().checkout(
      GulfSubjectRequestPayload(
        subjectId: state.selectedSubjectId!,
        packageId: state.selectedPackageId!,
        curriculumId: cubit.gulfCurriculumId!,
        notes: state.notes,
        discountCode: discountCode,
        paymentAddress: const PaymentAddress(
          city: TamaraDefaultAddress.city,
          region: TamaraDefaultAddress.region,
          line1: TamaraDefaultAddress.line1,
          line2: TamaraDefaultAddress.line2,
        ),
      ),
    );
  }
}
