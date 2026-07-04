import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/curriculum_management/data/mock_data/curriculum_mock_data.dart';
import 'package:bnan_app/features/curriculum_management/data/models/curriculum_model.dart';
import 'package:bnan_app/features/curriculum_management/presentation/views/widgets/curriculum_list.dart';
import 'package:bnan_app/features/curriculum_management/presentation/views/widgets/delete_confirmation_dialog.dart';
import 'package:bnan_app/features/curriculum_management/presentation/views/widgets/name_input_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

part 'curriculum_actions.dart';
part 'curriculum_delete_actions.dart';

class CurriculumManagementBody extends StatefulWidget {
  const CurriculumManagementBody({super.key});

  @override
  State<CurriculumManagementBody> createState() =>
      _CurriculumManagementBodyState();
}

class _CurriculumManagementBodyState extends State<CurriculumManagementBody> {
  final Set<String> _expandedCurriculums = {'saudi'};
  final Set<String> _expandedGrades = {'saudi-third-prep', 'saudi-second-prep'};
  late List<CurriculumModel> _curriculums;
  var _isInitialized = false;
  var _nextId = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) return;
    _curriculums = curriculumMockData(S.of(context));
    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: AddNewTopicButton(
            padding: EdgeInsetsDirectional.only(
              start: 17.5,
              end: 24.5,
              top: 8,
              bottom: 8,
            ),
            title: s.addNewCurriculum,
            path: ImageManager.plus,
            onTap: _addCurriculum,
          ),
        ),
        Expanded(
          child: CurriculumList(
            curriculums: _curriculums,
            expandedCurriculums: _expandedCurriculums,
            expandedGrades: _expandedGrades,
            onToggleCurriculum: _toggleCurriculum,
            onDeleteCurriculum: _deleteCurriculum,
            onAddGrade: _addGrade,
            onDeleteGrade: _deleteGrade,
            onAddSemester: _addSemester,
            onDeleteSemester: _deleteSemester,
            onToggleGrade: _toggleGrade,
          ),
        ),
      ],
    );
  }

  void _update(VoidCallback action) => setState(action);
}
