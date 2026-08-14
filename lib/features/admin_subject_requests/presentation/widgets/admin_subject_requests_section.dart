import 'package:bnan_app/features/admin_subject_requests/presentation/manager/admin_subject_requests_cubit.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/widgets/admin_subject_requests_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminSubjectRequestsSection extends StatefulWidget {
  const AdminSubjectRequestsSection({super.key});
  @override
  State<AdminSubjectRequestsSection> createState() =>
      _AdminSubjectRequestsSectionState();
}

class _AdminSubjectRequestsSectionState
    extends State<AdminSubjectRequestsSection> {
  final _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    _controller.addListener(_loadMore);
  }

  void _loadMore() {
    if (_controller.hasClients &&
        _controller.position.pixels >=
            _controller.position.maxScrollExtent - 200) {
      context.read<AdminSubjectRequestsCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SizedBox(height: 16),
      Expanded(child: AdminSubjectRequestsBuilder(controller: _controller)),
    ],
  );
}
