import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/subjects_management/data/models/subject_mock_data.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/get_subjects_cubit/get_subjects_cubit.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/get_subjects_cubit/get_subjects_state.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/subject_management_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubjectManagementList extends StatefulWidget {
  const SubjectManagementList({super.key});

  @override
  State<SubjectManagementList> createState() => _SubjectManagementListState();
}

class _SubjectManagementListState extends State<SubjectManagementList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_loadMore)
      ..dispose();
    super.dispose();
  }

  void _loadMore() {
    if (!mounted || !_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<GetSubjectsCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSubjectsCubit, GetSubjectsState>(
      builder: (context, state) {
        final cubit = context.read<GetSubjectsCubit>();
        final isLoading = state is GetSubjectsLoading;
        if (state is GetSubjectsFailure && cubit.subjects.isEmpty) {
          return const NoDataWidget();
        }
        if (!isLoading && cubit.subjects.isEmpty) {
          return const NoDataWidget();
        }
        final subjects = isLoading && cubit.subjects.isEmpty
            ? mockSubjects
            : cubit.subjects;
        final showLoader = state is GetSubjectsLoadingMore;
        return AppSkeletonizer(
          isLoading: isLoading,
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
            itemBuilder: (context, index) => index == subjects.length
                ? const Padding(
                    padding: EdgeInsetsDirectional.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : SubjectManagementListItem(
                    subject: subjects[index],
                    enabled: !isLoading,
                  ),
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemCount: subjects.length + (showLoader ? 1 : 0),
          ),
        );
      },
    );
  }
}
