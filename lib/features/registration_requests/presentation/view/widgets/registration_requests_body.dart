import 'package:bnan_app/core/shared_widget/filter_chip/custom_filter_tabs.dart';
import 'package:bnan_app/features/registration_requests/data/models/registration_request_filter.dart';
import 'package:bnan_app/features/registration_requests/presentation/manager/get_registration_requests_cubit/get_registration_requests_cubit.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_requests_bloc_builder.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationRequestsBody extends StatefulWidget {
  const RegistrationRequestsBody({super.key});

  @override
  State<RegistrationRequestsBody> createState() =>
      _RegistrationRequestsBodyState();
}

class _RegistrationRequestsBodyState extends State<RegistrationRequestsBody> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_loadMore);
  }

  void _loadMore() {
    if (!mounted || !_controller.hasClients) return;
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 200) {
      context.read<GetRegistrationRequestsCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_loadMore)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<GetRegistrationRequestsCubit>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
          child: CustomFilterTabs<RegistrationRequestFilter>(
            items: {
              RegistrationRequestFilter.approved: S.of(context).activated,
              RegistrationRequestFilter.pending: S.of(context).notActivated,
            },
            selectedItem: cubit.currentFilter,
            onChanged: (filter) {
              if (filter == cubit.currentFilter) return;
              cubit.getRegistrationRequests(filter: filter, refresh: true);
            },
          ),
        ),
        Expanded(
          child: RegistrationRequestsBlocBuilder(controller: _controller),
        ),
      ],
    );
  }
}
