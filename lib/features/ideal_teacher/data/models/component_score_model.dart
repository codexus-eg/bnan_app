import 'package:bnan_app/features/ideal_teacher/data/models/ideal_teacher_parser.dart';

class ComponentScoreModel {
  const ComponentScoreModel({
    this.points = 0,
    this.max = 0,
    this.available = true,
  });

  final num points;
  final num max;
  final bool available;

  factory ComponentScoreModel.fromJson(Object? json) {
    final map = IdealTeacherParser.map(json);
    return ComponentScoreModel(
      points: IdealTeacherParser.number(map['points']),
      max: IdealTeacherParser.number(map['max'] ?? map['maxPoints']),
      available: map.containsKey('available')
          ? IdealTeacherParser.boolean(map['available'])
          : true,
    );
  }
}

class RankingComponentsModel {
  const RankingComponentsModel({
    this.attendance = const ComponentScoreModel(),
    this.punctuality = const ComponentScoreModel(),
    this.interaction = const ComponentScoreModel(),
    this.weeklyTasks = const ComponentScoreModel(),
    this.grading = const ComponentScoreModel(),
  });

  final ComponentScoreModel attendance;
  final ComponentScoreModel punctuality;
  final ComponentScoreModel interaction;
  final ComponentScoreModel weeklyTasks;
  final ComponentScoreModel grading;

  factory RankingComponentsModel.fromJson(Object? json) {
    final map = IdealTeacherParser.map(json);
    return RankingComponentsModel(
      attendance: ComponentScoreModel.fromJson(map['attendance']),
      punctuality: ComponentScoreModel.fromJson(map['punctuality']),
      interaction: ComponentScoreModel.fromJson(map['interaction']),
      weeklyTasks: ComponentScoreModel.fromJson(map['weeklyTasks']),
      grading: ComponentScoreModel.fromJson(map['grading']),
    );
  }
}
