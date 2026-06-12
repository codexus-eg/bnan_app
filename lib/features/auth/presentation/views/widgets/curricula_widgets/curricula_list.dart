import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/features/auth/data/models/curriculum_card_model.dart';
import 'package:bnan_app/features/auth/presentation/manager/get_curriculums_cubit/get_curriculums_cubit.dart';
import 'package:bnan_app/features/auth/presentation/manager/get_curriculums_cubit/get_curriculums_state.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/curricula_widgets/curriculum_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurriculaList extends StatelessWidget {
  const CurriculaList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCurriculumsCubit, GetCurriculumsState>(
      builder: (context, state) {
        final isLoading = state is GetCurriculumsLoading;
        if (state is GetCurriculumsFailure) {
          return Center(child: Text(state.errorMessage));
        }
        final curriculumCards = state is GetCurriculumsSuccess
            ? state.curriculums.map(CurriculumCardModel.fromCurriculum).toList()
            : CurriculumCardModel.placeholderList();

        return AppSkeletonizer(
          isLoading: isLoading,
          child: Column(
            children: List.generate(curriculumCards.length, (index) {
              final curriculumCard = curriculumCards[index];

              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == curriculumCards.length - 1 ? 0 : 18,
                ),
                child: CurriculumCard(
                  curriculumCard: curriculumCard,
                  onTap: () {
                    if (isLoading) return;
                    MyNavigator.goTo(
                      context,
                      Routes.subscription,
                      extra: curriculumCard,
                    );
                  },
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
