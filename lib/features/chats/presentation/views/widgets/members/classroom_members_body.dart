import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/certificates_management/data/models/classroom_students_response_model.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_classroom_students_cubit/get_classroom_students_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_classroom_students_cubit/get_classroom_students_state.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/members/classroom_member_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassroomMembersBody extends StatelessWidget {
  const ClassroomMembersBody({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<GetClassroomStudentsCubit, GetClassroomStudentsState>(
        builder: (context, state) {
          if (state is GetClassroomStudentsFailure) {
            return Center(child: NoDataWidget(title: state.message));
          }
          final loading =
              state is GetClassroomStudentsLoading ||
              state is GetClassroomStudentsInitial;
          final students = state is GetClassroomStudentsSuccess
              ? state.response.data
              : const <ClassroomStudentModel>[
                  ClassroomStudentModel(id: '', fullName: 'Student'),
                  ClassroomStudentModel(id: '', fullName: 'Student'),
                  ClassroomStudentModel(id: '', fullName: 'Student'),
                ];
          if (!loading && students.isEmpty) {
            return Center(
              child: NoDataWidget(title: S.of(context).noStudentsInClassroom),
            );
          }
          return AppSkeletonizer(
            isLoading: loading,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: students.length,
              itemBuilder: (_, index) =>
                  ClassroomMemberCard(student: students[index]),
            ),
          );
        },
      );
}
