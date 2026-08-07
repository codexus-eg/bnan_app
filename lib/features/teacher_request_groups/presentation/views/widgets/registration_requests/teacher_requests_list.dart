import 'package:bnan_app/features/teacher_request_groups/data/models/registration_request_model.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/manager/teacher_registration_requests_cubit.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/views/widgets/registration_requests/teacher_requests_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherRequestsList extends StatefulWidget {
  const TeacherRequestsList({
    super.key,
    required this.requests,
    required this.isLoadingMore,
    this.loadMoreError,
  });
  final List<RegistrationRequestModel> requests;
  final bool isLoadingMore;
  final String? loadMoreError;

  @override
  State<TeacherRequestsList> createState() => _TeacherRequestsListState();
}

class _TeacherRequestsListState extends State<TeacherRequestsList> {
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(_loadMore);
  }

  void _loadMore() {
    if (controller.position.extentAfter < 200) {
      context.read<TeacherRegistrationRequestsCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TeacherRequestsListView(
    controller: controller,
    requests: widget.requests,
    isLoadingMore: widget.isLoadingMore,
    loadMoreError: widget.loadMoreError,
  );
}
