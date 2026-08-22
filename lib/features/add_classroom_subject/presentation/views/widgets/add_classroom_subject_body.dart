import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/features/add_classroom_subject/presentation/manager/add_classroom_subject_cubit.dart';
import 'package:bnan_app/features/add_classroom_subject/presentation/manager/add_classroom_subject_state.dart';
import 'package:bnan_app/features/add_classroom_subject/presentation/views/widgets/add_classroom_subject_form.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddClassroomSubjectBody extends StatelessWidget {
  const AddClassroomSubjectBody({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<AddClassroomSubjectCubit, AddClassroomSubjectState>(
        listenWhen: (previous, current) => previous.eventId != current.eventId,
        listener: (context, state) => showCustomSnackBar(
          context,
          state.submitted
              ? S.of(context).subjectCreatedSuccessfully
              : state.submitError ?? S.of(context).unexpectedError,
          state.submitted,
        ),
        builder: (context, state) => SingleChildScrollView(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 32),
          child: AddClassroomSubjectForm(state: state),
        ),
      );
}
