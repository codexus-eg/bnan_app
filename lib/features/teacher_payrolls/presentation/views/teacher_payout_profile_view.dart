import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_model.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/payout/teacher_payout_profile_cubit.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/payout/teacher_payout_profile_state.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_failure_view.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payout_profile_details.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payout_profile_form.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherPayoutProfileView extends StatefulWidget {
  const TeacherPayoutProfileView({super.key});

  @override
  State<TeacherPayoutProfileView> createState() =>
      _TeacherPayoutProfileViewState();
}

class _TeacherPayoutProfileViewState extends State<TeacherPayoutProfileView> {
  PayoutProfileModel? profile;
  bool editing = false;

  @override
  void initState() {
    super.initState();
    context.read<TeacherPayoutProfileCubit>().loadMine();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppbar(headerText: S.of(context).payrollPayoutDetails),
    body: BlocConsumer<TeacherPayoutProfileCubit, TeacherPayoutProfileState>(
      listener: _listen,
      builder: (context, state) {
        if (editing) {
          return PayoutProfileForm(
            initial: profile,
            selfService: true,
            popOnSuccess: false,
          );
        }
        if (state is TeacherPayoutProfileFailure) {
          return PayrollFailureView(
            message: state.message,
            onRetry: context.read<TeacherPayoutProfileCubit>().loadMine,
          );
        }
        if (state is TeacherPayoutProfileEmpty) return _empty();
        if (state is TeacherPayoutProfileSuccess) {
          return _details(state.profile);
        }
        return const AppSkeletonizer(isLoading: true, child: SizedBox.expand());
      },
    ),
  );

  void _listen(BuildContext context, TeacherPayoutProfileState state) {
    if (state is TeacherPayoutProfileEmpty) profile = null;
    if (state is! TeacherPayoutProfileSuccess) return;
    profile = state.profile;
    if (!editing) return;
    setState(() => editing = false);
    showCustomSnackBar(context, S.of(context).payoutProfileSaved, true);
  }

  Widget _empty() => _refreshable([
    Text(S.of(context).payoutProfileEmpty),
    const SizedBox(height: 16),
    CustomAppButton(
      text: S.of(context).payoutProfileAdd,
      onPressed: () => setState(() => editing = true),
    ),
  ]);

  Widget _details(PayoutProfileModel value) => _refreshable([
    PayoutProfileDetails(profile: value),
    const SizedBox(height: 16),
    CustomAppButton(
      text: S.of(context).payoutProfileEdit,
      onPressed: () => setState(() {
        profile = value;
        editing = true;
      }),
    ),
  ]);

  Widget _refreshable(List<Widget> children) => RefreshIndicator(
    onRefresh: context.read<TeacherPayoutProfileCubit>().loadMine,
    child: ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: children,
    ),
  );
}
