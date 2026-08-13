import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/attendance/presentation/manager/attendance_cubit.dart';
import 'package:bnan_app/features/attendance/presentation/manager/attendance_state.dart';
import 'package:bnan_app/features/attendance/presentation/views/widgets/attendance_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceView extends StatelessWidget {
  const AttendanceView({super.key, this.showBackButton = true});

  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        headerText: S.of(context).attendanceRegistration,
        iconNeeded: showBackButton,
      ),
      body: SafeArea(
        child: BlocConsumer<AttendanceCubit, AttendanceState>(
          listenWhen: (previous, current) =>
              previous.eventId != current.eventId,
          listener: (context, state) => showCustomSnackBar(
            context,
            state.eventMessage ?? S.of(context).failedToLoadAttendance,
            state.eventSuccess ?? false,
          ),
          builder: (context, state) => AttendanceBody(state: state),
        ),
      ),
    );
  }
}
