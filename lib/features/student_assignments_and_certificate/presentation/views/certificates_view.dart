import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_cubit.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/certificates_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CertificatesView extends StatelessWidget {
  const CertificatesView({super.key});

  @override
  Widget build(BuildContext context) {
    final isParent = SessionManager.instance.role == UserRole.parent;
    final body = CertificatesBody(isParent: isParent, showBackButton: true);
    return Scaffold(
      body: SafeArea(
        child: isParent
            ? BlocProvider(
                create: (_) =>
                    getIt<GetParentChildrenCubit>()..getParentChildren(),
                child: body,
              )
            : body,
      ),
    );
  }
}
