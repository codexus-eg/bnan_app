import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/payments/presentation/views/tamara_checkout_launcher.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/manager/student_subject_requests_cubit.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/manager/student_subject_requests_state.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/manager/subject_request_payment_cubit.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/manager/subject_request_payment_state.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/widgets/student_subject_requests_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentSubjectRequestsView extends StatefulWidget {
  const StudentSubjectRequestsView({super.key});
  @override
  State<StudentSubjectRequestsView> createState() =>
      _StudentSubjectRequestsViewState();
}

class _StudentSubjectRequestsViewState extends State<StudentSubjectRequestsView>
    with WidgetsBindingObserver {
  bool _paymentRestoreChecked = false;
  bool _returningHome = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<SubjectRequestPaymentCubit>().tamaraReturned();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppbar(headerText: S.of(context).requestNewLesson),
    body: MultiBlocListener(
      listeners: [
        BlocListener<StudentSubjectRequestsCubit, StudentSubjectRequestsState>(
          listenWhen: (old, next) =>
              old.availability?.registrationMode !=
                  next.availability?.registrationMode ||
              (old.message != next.message &&
                  next.message != null &&
                  next.availability != null),
          listener: _onStudentState,
        ),
        BlocListener<SubjectRequestPaymentCubit, SubjectRequestPaymentState>(
          listener: _onPayment,
        ),
      ],
      child:
          BlocBuilder<StudentSubjectRequestsCubit, StudentSubjectRequestsState>(
            builder: (context, state) {
              if (state.phase == SubjectRequestsPhase.loading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: ColorManager.mainColor14,
                  ),
                );
              }
              if (state.phase == SubjectRequestsPhase.failure &&
                  state.availability == null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: CustomAppButton(
                      text: state.message ?? S.of(context).retry,
                      onPressed: context
                          .read<StudentSubjectRequestsCubit>()
                          .load,
                    ),
                  ),
                );
              }
              return const StudentSubjectRequestsBody();
            },
          ),
    ),
  );

  Future<void> _onPayment(
    BuildContext context,
    SubjectRequestPaymentState state,
  ) async {
    if (state.phase == SubjectRequestPaymentPhase.openingTamara) {
      final url = state.payment?.checkoutUrl;
      if (url == null) return;
      final cubit = context.read<SubjectRequestPaymentCubit>();
      final result = await TamaraCheckoutLauncher.open(
        context,
        url,
        completionStream: cubit.stream.map(
          (value) => value.phase == SubjectRequestPaymentPhase.completed,
        ),
        isCompleted: () =>
            cubit.state.phase == SubjectRequestPaymentPhase.completed,
        onOpened: cubit.tamaraReturned,
      );
      if (!context.mounted) return;
      if (result.opened) {
        await context.read<SubjectRequestPaymentCubit>().tamaraReturned();
      } else {
        context.read<SubjectRequestPaymentCubit>().checkoutLaunchFailed(
          S.of(context).errorUnknown,
        );
      }
    } else if (state.phase == SubjectRequestPaymentPhase.completed) {
      await context.read<StudentSubjectRequestsCubit>().paymentCompleted();
      if (context.mounted) {
        context.read<SubjectRequestPaymentCubit>().completeHandling();
      }
    } else if (state.phase == SubjectRequestPaymentPhase.verificationTimeout) {
      showCustomSnackBar(
        context,
        S.of(context).subjectRequestPaymentTimeout,
        false,
      );
    } else if (state.message != null) {
      showCustomSnackBar(context, state.message!, false);
    }
  }

  Future<void> _onStudentState(
    BuildContext context,
    StudentSubjectRequestsState state,
  ) async {
    if (!_paymentRestoreChecked && state.availability != null) {
      _paymentRestoreChecked = true;
      if (state.availability!.registrationMode == RegistrationMode.gulf) {
        await context.read<SubjectRequestPaymentCubit>().restore();
        if (!context.mounted) return;
      }
    }
    if (state.message == null) return;
    final success =
        state.message == 'subject_request_submitted' ||
        state.message == 'subject_request_payment_completed';
    final message = state.message == 'subject_request_submitted'
        ? S.of(context).subjectRequestSubmitted
        : state.message == 'subject_request_payment_completed'
        ? S.of(context).subjectRequestPaymentCompleted
        : state.message!;
    showCustomSnackBar(context, message, success);
    if (success && !_returningHome) {
      _returningHome = true;
      if (Navigator.of(context).canPop()) {
        MyNavigator.pop(context);
      } else {
        MyNavigator.goToOffAll(context, Routes.home);
      }
    }
  }
}
