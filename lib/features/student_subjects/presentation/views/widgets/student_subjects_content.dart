import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/student_subjects/data/models/student_subject_model.dart';
import 'package:bnan_app/features/student_subjects/presentation/manager/get_student_subjects/get_student_subjects_cubit.dart';
import 'package:bnan_app/features/student_subjects/presentation/manager/get_student_subjects/get_student_subjects_state.dart';
import 'package:bnan_app/features/student_subjects/presentation/student_subjects_filter.dart';
import 'package:bnan_app/features/student_subjects/presentation/views/widgets/student_subjects_list.dart';
import 'package:bnan_app/features/student_subjects/presentation/views/widgets/student_subjects_terminal_view.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentSubjectsContent extends StatelessWidget {
  const StudentSubjectsContent({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetMySubjectsCubit, GetMySubjectsState>(
      builder: (context, state) {
        final terminal = studentSubjectsTerminalView(context, state);
        if (terminal != null) return terminal;
        final loading = state is! GetMySubjectsSuccess;
        final subjects = state is GetMySubjectsSuccess
            ? filterStudentSubjects(state.subjects, query)
            : _skeletonSubjects;
        if (!loading && subjects.isEmpty) {
          return NoDataWidget(title: S.of(context).noSubjectsMatchSearch);
        }
        return AppSkeletonizer(
          isLoading: loading,
          child: StudentSubjectsList(subjects: subjects),
        );
      },
    );
  }
}

const _skeletonSubjects = [
  StudentSubjectModel(id: '', name: 'Subject'),
  StudentSubjectModel(id: '', name: 'Subject'),
  StudentSubjectModel(id: '', name: 'Subject'),
];
