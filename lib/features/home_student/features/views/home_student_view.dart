import 'package:bnan_app/core/shared_widget/custom_app_drawer/custom_app_drawer.dart';
import 'package:bnan_app/core/shared_widget/custom_bottom_nav_bar/bottom_nav_item_model.dart';
import 'package:bnan_app/core/shared_widget/custom_bottom_nav_bar/custom_bottom_nav_bar.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/home_student/features/views/widgets/home_body.dart';
import 'package:bnan_app/features/home_student/features/views/widgets/student_home_page/student_drawer_items.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeStudentView extends StatefulWidget {
  const HomeStudentView({super.key});

  @override
  State<HomeStudentView> createState() => _HomeStudentViewState();
}

class _HomeStudentViewState extends State<HomeStudentView> {
  int currentIndex = 0;
  int drawerIndex = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  void changeIndex(int index) {
    setState(() => currentIndex = index);
  }

  void changeDrawerIndex(int index) {
    setState(() => drawerIndex = index);
    scaffoldKey.currentState?.closeDrawer();
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
        icon: ImageManager.trophyIcon,
        title: S.of(context).services,
      ),
      BottomNavItemModel(
        icon: ImageManager.userProfileIcon,
        title: S.of(context).myAccount,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorManager.mainColor14,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        key: scaffoldKey,
        drawer: CustomAppDrawer(
          userName: 'فهد ناصر',
          userSubtitle: S.of(context).primaryGradeFive,
          items: studentDrawerItems(context),
          selectedIndex: drawerIndex,
          onItemTap: changeDrawerIndex,
          onLogoutTap: () {},
        ),
        body: HomeStudentBody(
          index: currentIndex,
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
    );
  }
}