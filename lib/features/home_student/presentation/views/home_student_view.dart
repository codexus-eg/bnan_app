import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_drawer/custom_app_drawer.dart';
import 'package:bnan_app/core/shared_widget/custom_bottom_nav_bar/bottom_nav_item_model.dart';
import 'package:bnan_app/core/shared_widget/custom_bottom_nav_bar/custom_bottom_nav_bar.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/home_body.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/student_drawer_items.dart';
import 'package:bnan_app/features/student_profile/data/models/logged_user_model.dart';
import 'package:bnan_app/features/student_profile/presentation/manager/get_logged_user_cubit/get_logged_user_cubit.dart';
import 'package:bnan_app/features/student_profile/presentation/manager/get_logged_user_cubit/get_logged_user_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeStudentView extends StatefulWidget {
  const HomeStudentView({super.key});

  @override
  State<HomeStudentView> createState() => _HomeStudentViewState();
}

class _HomeStudentViewState extends State<HomeStudentView> {
  int currentIndex = 0;
  int drawerIndex = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<int, int> drawerToBottomNavIndex = {
    0: 0, // الرئيسية
    5: 1, // الجدول
    9: 2, // الواجبات
    4: 3, // الشهادات
    8: 1,
    10: 4, // حسابي
  };
  void changeIndex(int index) {
    setState(() => currentIndex = index);
  }

  void _goHomeTab() {
    setState(() {
      currentIndex = 0;
      drawerIndex = 0;
    });
  }

  void changeDrawerIndex(int index) {
    final bottomIndex = drawerToBottomNavIndex[index];

    scaffoldKey.currentState?.closeDrawer();

    if (bottomIndex != null) {
      setState(() {
        drawerIndex = index;
        currentIndex = bottomIndex;
      });
      return;
    }

    _goHomeTab();

    if (index == 2) MyNavigator.goTo(context, Routes.requestLesson);
    if (index == 3) MyNavigator.goTo(context, Routes.groups);
    if (index == 7) MyNavigator.goTo(context, Routes.notification);
  }

  List<BottomNavItemModel> _items(BuildContext context) {
    return [
      BottomNavItemModel(
        icon: ImageManager.homeIcon,
        title: S.of(context).home,
      ),
      BottomNavItemModel(
        icon: ImageManager.tableIcon,
        title: S.of(context).schedule,
      ),
      BottomNavItemModel(
        icon: ImageManager.fileIcon,
        title: S.of(context).assignments,
      ),
      BottomNavItemModel(
        icon: ImageManager.certificateBadgeIcon,
        title: S.of(context).certificates,
      ),
      BottomNavItemModel(
        icon: ImageManager.userProfileIcon,
        title: S.of(context).myAccount,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      GetLoggedUserCubit,
      GetLoggedUserState,
      LoggedUserModel
    >(
      selector: (state) {
        if (state is GetLoggedUserSuccess) {
          return state.loggedUser;
        }
        return LoggedUserModel.placeholder();
      },
      builder: (context, loggedUser) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: ColorManager.mainColor14,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          child: PopScope(
            canPop: currentIndex == 0,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;

              if (currentIndex != 0) {
                _goHomeTab();
              }
            },
            child: Scaffold(
              key: scaffoldKey,
              drawer: currentIndex == 0
                  ? CustomAppDrawer(
                      userName: loggedUser.firstTwoNames,
                      userSubtitle: loggedUser.gradeName,
                      items: studentDrawerItems(context),
                      //TODO edit this
                      selectedIndex: 0,
                      onItemTap: changeDrawerIndex,
                      onLogoutTap: () async {
                        await GetLoggedUserCubit.get(context).logout();
                        if (!context.mounted) return;
                        MyNavigator.goToOffAll(context, Routes.logIn);
                        showCustomSnackBar(
                          context,
                          S.of(context).logoutSuccess,
                          true,
                        );
                      },
                    )
                  : null,
              body: HomeStudentBody(
                index: currentIndex,
                userName: loggedUser.firstTwoNames,
                onMenuTap: () {
                  scaffoldKey.currentState?.openDrawer();
                },
              ),
              bottomNavigationBar: CustomBottomNavBar(
                items: _items(context),
                currentIndex: currentIndex,
                onTap: changeIndex,
              ),
            ),
          ),
        );
      },
    );
  }
}
