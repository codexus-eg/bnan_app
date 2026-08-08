import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/ideal_student/data/models/ideal_student_item_model.dart';
import 'package:bnan_app/features/ideal_student/presentation/views/widgets/ideal_student_rank_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class IdealStudentsRankedList extends StatelessWidget {
  const IdealStudentsRankedList({super.key, required this.students});
  final List<IdealStudentItemModel> students;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).weeklyIdealStudentsRanking,
            style: StylesManager.styleBold14(
              context,
            ).copyWith(color: ColorManager.mainColor15),
          ),
          const SizedBox(height: 8),
          if (students.isEmpty)
            const SizedBox(height: 220, child: NoDataWidget())
          else
            ...students.map(
              (student) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: IdealStudentRankCard(student: student),
              ),
            ),
        ],
      ),
    );
  }
}
