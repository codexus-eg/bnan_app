import 'package:bnan_app/core/app_routes/home_route_resolver.dart';
import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/session/saved_account_store.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/saved_accounts/presentation/widgets/saved_account_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SavedAccountsView extends StatefulWidget {
  const SavedAccountsView({super.key});

  @override
  State<SavedAccountsView> createState() => _SavedAccountsViewState();
}

class _SavedAccountsViewState extends State<SavedAccountsView> {
  List<SavedAccount> accounts = const [];
  String? switchingId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppbar(
      headerText: S.of(context).savedAccounts,
      iconNeeded: false,
    ),
    body: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              S.of(context).chooseSavedAccount,
              style: StylesManager.styleRegular14(context),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: accounts.isEmpty
                  ? NoDataWidget(title: S.of(context).noSavedAccounts)
                  : ListView.separated(
                      itemCount: accounts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        final account = accounts[index];
                        return SavedAccountCard(
                          account: account,
                          loading: switchingId == account.userId,
                          onTap: () => _switch(account),
                          onRemove: () => _remove(account.userId),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
            CustomAppButton(
              text: S.of(context).loginWithAnotherAccount,
              onPressed: switchingId == null ? _loginWithAnother : null,
            ),
          ],
        ),
      ),
    ),
  );

  Future<void> _load() async {
    final values = await SavedAccountStore.load();
    if (mounted) setState(() => accounts = values);
  }

  Future<void> _remove(String userId) async {
    final values = await SavedAccountStore.remove(userId);
    if (mounted) setState(() => accounts = values);
  }

  Future<void> _switch(SavedAccount account) async {
    if (switchingId != null) return;
    setState(() => switchingId = account.userId);
    try {
      await SessionManager.instance.clearSession();
      final response = await getIt<ApiConsumer>().post(
        EndPoints.refreshToken,
        data: {'refreshToken': account.refreshToken},
      );
      final tokens = _tokens(response);
      await SessionManager.instance.saveSession(
        accessToken: tokens.$1,
        refreshToken: tokens.$2,
        userId: account.userId,
        userRole: account.role,
        userName: account.name,
        userEmail: account.email,
        userPhone: account.phone,
        registrationMode: account.registrationMode,
        registrationModes: account.registrationModes,
      );
      final home = HomeRouteResolver.forRole(account.role);
      if (!mounted || home == null) return;
      MyNavigator.goToOffAll(context, home);
    } on AppException catch (error) {
      if (!mounted) return;
      if ({400, 401, 403}.contains(error.statusCode)) {
        _openLogin(account);
      } else {
        showCustomSnackBar(context, error.message, false);
      }
    } catch (error) {
      if (mounted) showCustomSnackBar(context, error.toString(), false);
    } finally {
      if (mounted) setState(() => switchingId = null);
    }
  }

  (String, String) _tokens(Object? response) {
    final root = response is Map
        ? Map<String, dynamic>.from(response)
        : const <String, dynamic>{};
    final data = root['data'] is Map
        ? Map<String, dynamic>.from(root['data'] as Map)
        : root;
    final access = (root['token'] ?? data['token'] ?? data['accessToken'])
        ?.toString()
        .trim();
    final refresh = (root['refreshToken'] ?? data['refreshToken'])
        ?.toString()
        .trim();
    if (access?.isEmpty != false || refresh?.isEmpty != false) {
      throw AppException(
        S.current.errorUnauthorized,
        responseReceived: true,
        statusCode: 401,
      );
    }
    return (access!, refresh!);
  }

  void _openLogin(SavedAccount account) => MyNavigator.goToOffAll(
    context,
    Routes.directLogIn,
    extra: account.identifier,
  );

  void _loginWithAnother() =>
      MyNavigator.goToOffAll(context, Routes.directLogIn);
}
