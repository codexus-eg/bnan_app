import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/manager/teacher_registration_requests_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherRequestsFailureView extends StatelessWidget {
  const TeacherRequestsFailureView({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: context.read<TeacherRegistrationRequestsCubit>().refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.6,
            child: Center(
              child: Padding(
                padding: const EdgeInsetsDirectional.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    NoDataWidget(title: message),
                    const SizedBox(height: 12),
                    CustomAppButton(
                      text: S.of(context).retry,
                      onPressed: context
                          .read<TeacherRegistrationRequestsCubit>()
                          .refresh,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
