import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/attendance/presentation/manager/attendance_cubit.dart';
import 'package:bnan_app/features/attendance/presentation/manager/attendance_state.dart';
import 'package:bnan_app/features/attendance/presentation/views/widgets/attendance_student_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceContent extends StatelessWidget {
  const AttendanceContent({super.key, required this.state});
  final AttendanceState state;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    if (state.errorMessage != null) {
      return Center(child: _Message(text: state.errorMessage!, retry: true));
    }
    if (state.loadingClassrooms ||
        state.loadingSessions ||
        state.loadingStudents) {
      return AppSkeletonizer(
        isLoading: true,
        child: Column(
          children: List.generate(
            3,
            (_) => const SizedBox(
              height: 72,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: ColorManager.greyF8F9,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (state.grades.isEmpty) {
      return NoDataWidget(title: s.noClassroomsAvailable);
    }
    if (state.selectedGradeId == null) {
      return NoDataWidget(title: s.selectGradeToViewAttendance);
    }
    final classrooms = state.classrooms.where(
      (item) => item.grade.id == state.selectedGradeId,
    );
    if (classrooms.isEmpty) return NoDataWidget(title: s.noClassroomsAvailable);
    if (state.selectedClassroomId == null) {
      return NoDataWidget(title: s.selectClassroom);
    }
    if (state.sessions.isEmpty) {
      return NoDataWidget(title: s.noLessonsAvailable);
    }
    if (state.selectedSessionId == null) {
      return NoDataWidget(title: s.selectLesson);
    }
    if (state.students.isEmpty) {
      return NoDataWidget(title: s.noStudentsInClassroom);
    }
    final classroom = state.classrooms
        .where((item) => item.id == state.selectedClassroomId)
        .firstOrNull;
    final grade = state.grades
        .where((item) => item.id == state.selectedGradeId)
        .firstOrNull;
    final subtitle = [
      grade?.name,
      classroom?.name,
    ].whereType<String>().where((item) => item.isNotEmpty).join(' - ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          s.attendanceStudentsTitle(subtitle),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: state.students.length,
            itemBuilder: (context, index) => AttendanceStudentCard(
              student: state.students[index],
              subtitle: subtitle,
            ),
          ),
        ),
        const SizedBox(height: 8),
        CustomAppButton(
          text: s.attendanceRegistration,
          isLoading: state.submitting,
          onPressed: state.submitting
              ? null
              : context.read<AttendanceCubit>().submit,
        ),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, required this.retry});
  final String text;
  final bool retry;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      NoDataWidget(title: text),
      if (retry)
        CustomAppButton(
          text: S.of(context).retry,
          onPressed: context.read<AttendanceCubit>().retry,
        ),
    ],
  );
}
