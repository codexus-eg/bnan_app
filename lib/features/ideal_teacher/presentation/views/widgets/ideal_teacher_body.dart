import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/shared_widget/filter_chip/custom_filter_tabs.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_cubit.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_state.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/classroom_points_tab_view.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/supervisor_teachers_view.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IdealTeacherBody extends StatefulWidget {
  const IdealTeacherBody({super.key});
  @override
  State<IdealTeacherBody> createState() => _IdealTeacherBodyState();
}

class _IdealTeacherBodyState extends State<IdealTeacherBody> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final cubit = context.read<SupervisorIdealTeacherCubit>();
        if (cubit.state.teachers.isEmpty) {
          cubit.loadTeachers();
        }
      }
    });
  }

  void _loadMore() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 160) {
      context.read<SupervisorIdealTeacherCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isAdmin = SessionManager.instance.role == UserRole.admin;

    final tabs = <IdealTeacherTab, String>{
      IdealTeacherTab.idealTeacher: isAdmin
          ? (isAr ? 'المعلمون' : 'Teachers')
          : (isAr ? 'المعلم المثالي' : s.idealTeacher),
      IdealTeacherTab.classroomPoints: isAr ? 'نقاط الفصول' : 'Classroom Points',
    };

    return BlocConsumer<SupervisorIdealTeacherCubit, SupervisorIdealTeacherState>(
      listenWhen: (previous, current) =>
          current.issuanceEventId != previous.issuanceEventId &&
          current.issuanceEventId > 0,
      listener: (context, state) {
        if (state.issuanceSuccess == true) {
          showCustomSnackBar(
            context,
            s.idealTeacherIssuedSuccessfully,
            true,
          );
        } else if (state.issuanceSuccess == false &&
            (state.issuanceMessage?.isNotEmpty ?? false)) {
          showCustomSnackBar(context, state.issuanceMessage!, false);
        }
      },
      builder: (context, state) {
        final cubit = context.read<SupervisorIdealTeacherCubit>();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 4),
              child: CustomFilterTabs<IdealTeacherTab>(
                items: tabs,
                selectedItem: state.activeTab,
                onChanged: (tab) {
                  _searchController.clear();
                  cubit.setSearchQuery('');
                  cubit.setActiveTab(tab);
                  if (tab == IdealTeacherTab.idealTeacher &&
                      state.teachers.isEmpty) {
                    cubit.loadTeachers();
                  }
                },
              ),
            ),
            Expanded(
              child: state.activeTab == IdealTeacherTab.idealTeacher
                  ? SupervisorTeachersView(
                      state: state,
                      searchController: _searchController,
                      scrollController: _scrollController,
                    )
                  : ClassroomPointsTabView(
                      state: state,
                      scrollController: _scrollController,
                    ),
            ),
          ],
        );
      },
    );
  }
}
