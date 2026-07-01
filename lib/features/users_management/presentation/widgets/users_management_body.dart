import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/users_management/data/user_mock_data.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/card/user_card.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/users_management_actions.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/users_management_search.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class UsersManagementBody extends StatelessWidget {
  const UsersManagementBody({super.key});


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
            child: Column(
              children: [
                CustomAppbar(headerText: S.of(context).usersManagement,iconNeeded: false,),
                const UsersManagementActions(),
                const SizedBox(height: 16),
                const UsersManagementSearch(),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
              itemBuilder: (context, index) {
                return UserCard(user: usersMock[index]);
              },
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemCount: usersMock.length,
            ),
          ),
        ],
      ),
    );
  }
}
