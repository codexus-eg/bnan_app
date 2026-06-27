import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class HomeStateModel {
  const HomeStateModel({
    required this.icon,
    required this.value,
    required this.title,
     this.iconColor,
  });

  final String icon;
  final String value;
  final String title;
  final Color? iconColor;
}

final studentHomeState = [
  HomeStateModel(
    icon: ImageManager.arrowGrowthIcon,
    value: '95%',
    title: S.current.attendance,
    iconColor: Color(0xff75C8EE),
  ),
  HomeStateModel(
    icon: ImageManager.starIcon,
    value:'4.8',
    title: S.current.interaction,
    iconColor: Color(0xffE6A72A),
  ),
  HomeStateModel(
    icon: ImageManager.trophyIcon,
    value: '12',
    title: S.current.certificates,
    iconColor: Color(0xff3E7BD9),
  ),
];
final teacherHomeState = [
  HomeStateModel(
    icon: ImageManager.teacherBookTwoIcon,
    value: '6',
    title: S.current.classes,
  ),
  HomeStateModel(
    icon: ImageManager.userProfileGroupIcon,
    value: '84',
    title: S.current.students,
  ),
  HomeStateModel(
    icon: ImageManager.teacherBookOneIcon,
    value:'3',
    title: S.current.subject,
  ),
];