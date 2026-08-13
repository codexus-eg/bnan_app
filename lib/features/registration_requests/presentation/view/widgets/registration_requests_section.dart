import 'package:bnan_app/features/registration_requests/presentation/manager/get_registration_requests_cubit/get_registration_requests_cubit.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_requests_bloc_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationRequestsSection extends StatefulWidget {
  const RegistrationRequestsSection({super.key});
  @override
  State<RegistrationRequestsSection> createState() =>
      _RegistrationRequestsSectionState();
}

class _RegistrationRequestsSectionState
    extends State<RegistrationRequestsSection> {
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
      context.read<GetRegistrationRequestsCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RegistrationRequestsBlocBuilder(controller: _controller);
  }
}
