import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/manager/teacher_registration_requests_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherRequestsListFooter extends StatelessWidget {
  const TeacherRequestsListFooter({
    super.key,
    required this.loading,
    this.error,
  });
  final bool loading;
  final String? error;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Padding(
        padding: EdgeInsetsDirectional.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (error == null) return const SizedBox.shrink();
    return Column(
      children: [
        Text(error!, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        CustomAppButton(
          text: S.of(context).retry,
          height: 40,
          onPressed: context.read<TeacherRegistrationRequestsCubit>().loadMore,
        ),
      ],
    );
  }
}
