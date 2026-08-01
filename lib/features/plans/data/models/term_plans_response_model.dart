import 'package:bnan_app/features/plans/data/models/plan_classroom_model.dart';
import 'package:bnan_app/features/plans/data/models/plan_model_parser.dart';

class TermPlansResponseModel {
  const TermPlansResponseModel({
    this.success = false,
    this.results = 0,
    this.data = const TermPlansDataModel(),
    this.items = const [],
  });

  final bool success;
  final int results;
  final TermPlansDataModel data;
  final List<TermPlansDataModel> items;

  factory TermPlansResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final items = PlanModelParser.maps(
      rawData,
    ).map(TermPlansDataModel.fromJson).toList();
    final legacyData = rawData is Map
        ? TermPlansDataModel.fromJson(Map<String, dynamic>.from(rawData))
        : items.firstOrNull ?? const TermPlansDataModel();
    return TermPlansResponseModel(
      success: PlanModelParser.boolean(json['success']),
      results: PlanModelParser.integer(json['results']),
      data: legacyData,
      items: items.isEmpty && rawData is Map ? [legacyData] : items,
    );
  }
}

class TermPlansDataModel {
  const TermPlansDataModel({
    this.classroom = const PlanClassroomModel(),
    this.subjects = const [],
  });

  final PlanClassroomModel classroom;
  final List<TermPlanSubjectModel> subjects;

  factory TermPlansDataModel.fromJson(Map<String, dynamic> json) {
    return TermPlansDataModel(
      classroom: PlanClassroomModel.fromJson(
        PlanModelParser.map(json['classroom']),
      ),
      subjects: PlanModelParser.maps(
        json['subjects'],
      ).map(TermPlanSubjectModel.fromJson).toList(),
    );
  }
}

class TermPlanSubjectModel {
  const TermPlanSubjectModel({
    this.id = '',
    this.name = '',
    this.plans = const [],
  });

  final String id;
  final String name;
  final List<TermPlanItemModel> plans;

  factory TermPlanSubjectModel.fromJson(Map<String, dynamic> json) {
    return TermPlanSubjectModel(
      id: PlanModelParser.id(json),
      name: PlanModelParser.string(json['name']),
      plans: PlanModelParser.maps(
        json['plans'],
      ).map(TermPlanItemModel.fromJson).toList(),
    );
  }
}

class TermPlanItemModel {
  const TermPlanItemModel({this.attachment = ''});

  final String attachment;

  factory TermPlanItemModel.fromJson(Map<String, dynamic> json) {
    return TermPlanItemModel(
      attachment: PlanModelParser.string(json['attachment']),
    );
  }
}
